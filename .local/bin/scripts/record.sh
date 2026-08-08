#!/usr/bin/env bash
set -Eeuo pipefail

# A small, backend-aware screen recorder.  With no arguments it opens an
# interactive wizard; the subcommands are useful from keybindings and scripts.

SCRIPT_NAME=$(basename "$0")
OUTPUT_DIR=${RECORD_OUTPUT_DIR:-"$HOME/vids/recordings"}
FPS=30
FPS_SET=false
QUALITY=balanced
SOURCE=full
AUDIO_MODE=none
AUDIO_DEVICE=default
OUTPUT=
OPEN_AFTER=false
FORCE=false
NO_CURSOR=false
INTERACTIVE=false

if [[ -n "${XDG_RUNTIME_DIR:-}" && -d "$XDG_RUNTIME_DIR" && -w "$XDG_RUNTIME_DIR" ]]; then
  RUNTIME_DIR=$XDG_RUNTIME_DIR
else
  RUNTIME_DIR=/tmp
fi
STATE_DIR="$RUNTIME_DIR/record-${UID}"
PID_FILE="$STATE_DIR/pid"
OUTPUT_FILE="$STATE_DIR/output"
START_FILE="$STATE_DIR/start"

# Some restricted sessions advertise XDG_RUNTIME_DIR but do not allow writes.
# Probe it once so `record start` and `record stop` choose the same fallback.
if ! mkdir -p "$STATE_DIR" 2>/dev/null; then
  RUNTIME_DIR=/tmp
  STATE_DIR="$RUNTIME_DIR/record-${UID}"
  PID_FILE="$STATE_DIR/pid"
  OUTPUT_FILE="$STATE_DIR/output"
  START_FILE="$STATE_DIR/start"
  mkdir -p "$STATE_DIR" || {
    printf 'Error: Could not create recording state directory.\n' >&2
    exit 1
  }
fi
chmod 700 "$STATE_DIR"

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

info() { printf '%s\n' "$*"; }

need() {
  command -v "$1" >/dev/null 2>&1 || die "'$1' is required but was not found."
}

notify() {
  command -v notify-send >/dev/null 2>&1 && notify-send "Screen recording" "$1" >/dev/null 2>&1 || true
}

usage() {
  cat <<EOF
Usage:
  $SCRIPT_NAME                    Open the recording wizard
  $SCRIPT_NAME start [options]   Start a recording
  $SCRIPT_NAME stop               Stop the active recording
  $SCRIPT_NAME status             Show recording status
  $SCRIPT_NAME open [FILE|latest] Play a recording in mpv

Start options:
  -r, --region             Select a region instead of the full screen
  -f, --fps FPS            Framerate (default: $FPS)
  -q, --quality PRESET     compact, balanced, or quality
  -a, --audio[=SOURCE]     Record audio (default, or a PulseAudio source)
      --audio none         Disable audio explicitly
  -o, --output FILE        Output file (default: $OUTPUT_DIR/rec_TIMESTAMP.mp4)
      --dir DIR            Directory used for the default output file
  -p, --open               Open the result in mpv when finished
      --force              Replace an existing output file
      --no-cursor          Do not capture the mouse cursor (Wayland)
  -h, --help               Show this help

Examples:
  $SCRIPT_NAME
  $SCRIPT_NAME start --region --audio=default
  $SCRIPT_NAME start --quality compact --output ~/vids/demo.mp4
  $SCRIPT_NAME stop
EOF
}

state_exists() { [[ -s "$PID_FILE" ]]; }

pid_is_running() {
  local pid process_name
  state_exists || return 1
  pid=$(<"$PID_FILE")
  [[ "$pid" =~ ^[0-9]+$ ]] || return 1
  kill -0 "$pid" 2>/dev/null || return 1
  process_name=$(ps -p "$pid" -o comm= 2>/dev/null | tr -d ' ')
  [[ "$process_name" == ffmpeg || "$process_name" == wl-screenrec ]]
}

clear_state() {
  rm -f "$PID_FILE" "$OUTPUT_FILE" "$START_FILE"
  rmdir "$STATE_DIR" 2>/dev/null || true
}

write_state() {
  mkdir -p "$STATE_DIR"
  chmod 700 "$STATE_DIR"
  printf '%s\n' "$1" >"$PID_FILE"
  printf '%s\n' "$OUTPUT" >"$OUTPUT_FILE"
  printf '%s\n' "$(date +%s)" >"$START_FILE"
}

choose() {
  local prompt=$1
  shift
  need fzf
  printf '%s\n' "$@" | fzf --height=40% --reverse --border --prompt="$prompt "
}

interactive_setup() {
  local selected default_output answer
  local -a audio_choices

  selected=$(choose 'Source>' $'Full screen\tfull' $'Select region\tregion') || exit 130
  SOURCE=${selected##*$'\t'}

  selected=$(choose 'Quality>' $'Balanced (30 fps, good size)\tbalanced' \
    $'Quality (60 fps, sharper)\tquality' $'Compact (30 fps, smaller)\tcompact') || exit 130
  QUALITY=${selected##*$'\t'}

  audio_choices=($'No audio\tnone' $'Default audio source\tdefault')
  if command -v pactl >/dev/null 2>&1; then
    while IFS=$'\t' read -r _ name _; do
      [[ -n "$name" ]] && audio_choices+=("$name\t$name")
    done < <(pactl list short sources 2>/dev/null || true)
  fi
  selected=$(choose 'Audio>' "${audio_choices[@]}") || exit 130
  AUDIO_MODE=${selected##*$'\t'}
  [[ "$AUDIO_MODE" != none && "$AUDIO_MODE" != default ]] && AUDIO_DEVICE=$AUDIO_MODE

  default_output="$OUTPUT_DIR/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"
  printf 'Output file [%s]: ' "$default_output"
  IFS= read -r answer || true
  OUTPUT=${answer:-$default_output}

  printf 'Open in mpv when finished? [y/N]: '
  IFS= read -r answer || true
  [[ "$answer" =~ ^[Yy]([Ee][Ss])?$ ]] && OPEN_AFTER=true
}

apply_quality() {
  case "$QUALITY" in
    compact) [[ "$FPS_SET" == true ]] || FPS=30; PRESET=veryfast; CRF=28 ;;
    balanced) [[ "$FPS_SET" == true ]] || FPS=30; PRESET=ultrafast; CRF=23 ;;
    quality) [[ "$FPS_SET" == true ]] || FPS=60; PRESET=fast; CRF=18 ;;
    *) die "Unknown quality preset '$QUALITY' (use compact, balanced, or quality)." ;;
  esac
}

detect_session() {
  if [[ -n "${XDG_SESSION_TYPE:-}" ]]; then
    printf '%s\n' "$XDG_SESSION_TYPE"
  elif [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    printf 'wayland\n'
  else
    printf 'x11\n'
  fi
}

select_wayland_geometry() {
  need slurp
  info 'Select a region on screen...' >&2
  slurp
}

select_x11_geometry() {
  need slop
  info 'Select a region on screen...' >&2
  local geometry size x y
  geometry=$(slop -f '%wx%h+%x+%y') || die 'Region selection was cancelled.'
  if [[ "$geometry" =~ ^([0-9]+x[0-9]+)\+([0-9]+)\+([0-9]+)$ ]]; then
    size=${BASH_REMATCH[1]}
    x=${BASH_REMATCH[2]}
    y=${BASH_REMATCH[3]}
    printf '%s|+%s,%s\n' "$size" "$x" "$y"
  else
    die "Could not parse region geometry: $geometry"
  fi
}

x11_screen_size() {
  local size
  size=$(xrandr --current 2>/dev/null | awk '
    / connected primary/ { split($4, a, "+"); print a[1]; exit }
    / connected/ { split($3, a, "+"); print a[1]; exit }
  ' || true)
  if [[ -z "$size" ]] && command -v xdpyinfo >/dev/null 2>&1; then
    size=$(xdpyinfo | awk '/dimensions/{print $2; exit}')
  fi
  [[ "$size" =~ ^[0-9]+x[0-9]+$ ]] || die 'Could not determine the X11 screen size. Install xrandr or xdpyinfo.'
  printf '%s\n' "$size"
}

audio_requested() { [[ "$AUDIO_MODE" != none ]]; }

build_wayland_command() {
  local -n command_ref=$1
  local geometry=$2
  command_ref=(wl-screenrec --filename "$TEMP_OUTPUT" --max-fps "$FPS" \
    --ffmpeg-encoder libx264 --encode-pixfmt yuv420p \
    --ffmpeg-encoder-options "preset=$PRESET,crf=$CRF")
  [[ "$SOURCE" == region ]] && command_ref+=(--geometry "$geometry")
  [[ "$NO_CURSOR" == true ]] && command_ref+=(--no-cursor)
  if audio_requested; then
    command_ref+=(--audio --ffmpeg-audio-encoder aac)
    [[ "$AUDIO_MODE" != default ]] && command_ref+=(--audio-device "$AUDIO_DEVICE")
  fi
}

build_x11_command() {
  local -n command_ref=$1
  local size=$2 offset=$3
  command_ref=(ffmpeg -hide_banner -loglevel warning -nostdin \
    -f x11grab -framerate "$FPS" -video_size "$size" \
    -i "${DISPLAY:-:0}${offset}")
  if audio_requested; then
    command_ref+=(-f pulse -i "$AUDIO_DEVICE")
  fi
  command_ref+=(-map 0:v:0)
  if audio_requested; then
    command_ref+=(-map 1:a:0 -c:a aac -b:a 192k)
  fi
  command_ref+=(-c:v libx264 -preset "$PRESET" -crf "$CRF" -pix_fmt yuv420p "$TEMP_OUTPUT")
}

finalize_recording() {
  need ffmpeg
  if [[ "${OUTPUT,,}" == *.mkv ]]; then
    mv -f "$TEMP_OUTPUT" "$OUTPUT"
    return
  fi
  info "Finalizing $OUTPUT..."
  ffmpeg -hide_banner -loglevel error -nostdin -y -i "$TEMP_OUTPUT" -map 0 -c copy "$OUTPUT"
  rm -f "$TEMP_OUTPUT"
}

start_recording() {
  local session geometry size offset child_status
  local -a command
  need ffmpeg
  apply_quality

  session=$(detect_session)
  [[ "$session" == wayland || "$session" == x11 ]] || die "Unsupported session type '$session'."
  [[ -n "$OUTPUT" ]] || OUTPUT="$OUTPUT_DIR/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"
  [[ "$OUTPUT" = /* ]] || OUTPUT=$(realpath -m "$OUTPUT")
  mkdir -p "$(dirname "$OUTPUT")"
  if [[ -e "$OUTPUT" && "$FORCE" != true ]]; then
    die "Output already exists: $OUTPUT (use --force to replace it)."
  fi
  TEMP_OUTPUT="$OUTPUT.part.mkv"
  rm -f "$TEMP_OUTPUT"

  if pid_is_running; then
    die "A recording is already running (PID $(<"$PID_FILE"))."
  else
    clear_state
  fi

  if [[ "$session" == wayland ]]; then
    need wl-screenrec
    geometry=
    [[ "$SOURCE" == region ]] && geometry=$(select_wayland_geometry)
    build_wayland_command command "$geometry"
  else
    [[ "$SOURCE" == region ]] && {
      local region_data
      region_data=$(select_x11_geometry)
      size=${region_data%%|*}
      offset=${region_data#*|}
    } || {
      size=$(x11_screen_size)
      offset=+0,0
    }
    build_x11_command command "$size" "$offset"
  fi

  info "Recording ${FPS}fps → $OUTPUT"
  info 'Press Ctrl+C or run "record.sh stop" to finish.'
  notify "Recording started"
  "${command[@]}" &
  RECORD_PID=$!
  write_state "$RECORD_PID"
  forward_stop() {
    [[ -n "${RECORD_PID:-}" ]] && kill -INT "$RECORD_PID" 2>/dev/null || true
  }
  trap forward_stop INT TERM
  set +e
  wait "$RECORD_PID"
  child_status=$?
  set -e
  trap - INT TERM

  if [[ ! -s "$TEMP_OUTPUT" ]]; then
    clear_state
    notify 'Recording failed'
    die "Recording failed (exit status $child_status)."
  fi
  if ! finalize_recording; then
    clear_state
    notify 'Recording could not be finalized'
    die "Could not finalize recording. The temporary file remains at $TEMP_OUTPUT."
  fi
  clear_state
  info "Saved to $OUTPUT"
  notify "Saved to $OUTPUT"
  [[ "$OPEN_AFTER" == true ]] && open_recording "$OUTPUT"
}

stop_recording() {
  state_exists || die 'No recording is active.'
  if ! pid_is_running; then
    clear_state
    die 'No recording is active (removed stale state).'
  fi
  local pid
  pid=$(<"$PID_FILE")
  kill -INT "$pid"
  info "Stopping recording (PID $pid)..."
}

status_recording() {
  if pid_is_running; then
    local pid output started elapsed
    pid=$(<"$PID_FILE")
    output=$(<"$OUTPUT_FILE")
    started=$(<"$START_FILE")
    elapsed=$(( $(date +%s) - started ))
    info "Recording: active"
    info "PID:      $pid"
    info "Duration: ${elapsed}s"
    info "Output:   $output"
  else
    state_exists && clear_state
    info 'Recording: inactive'
  fi
}

latest_recording() {
  local newest=
  while IFS= read -r -d '' file; do
    newest=$file
    break
  done < <(find "$OUTPUT_DIR" -maxdepth 1 -type f \( -name '*.mp4' -o -name '*.mkv' -o -name '*.webm' \) -printf '%T@ %p\0' 2>/dev/null | sort -zrn | sed -z 's/^[^ ]* //')
  [[ -n "$newest" ]] || die "No recordings found in $OUTPUT_DIR."
  printf '%s\n' "$newest"
}

open_recording() {
  local file=${1:-latest}
  [[ "$file" == latest ]] && file=$(latest_recording)
  [[ -f "$file" ]] || die "Recording not found: $file"
  need mpv
  exec mpv "$file"
}

parse_start_options() {
  while (($#)); do
    case "$1" in
      -r|--region) SOURCE=region ;;
      --source=*) SOURCE=${1#*=} ;;
      -f|--fps) (($# >= 2)) || die "$1 requires a value"; FPS=$2; FPS_SET=true; shift ;;
      --fps=*) FPS=${1#*=}; FPS_SET=true ;;
      -q|--quality) (($# >= 2)) || die "$1 requires a value"; QUALITY=$2; shift ;;
      --quality=*) QUALITY=${1#*=} ;;
      -a) AUDIO_MODE=default ;;
      --audio)
        if (($# >= 2)) && [[ "$2" != -* ]]; then
          AUDIO_MODE=$2
          [[ "$AUDIO_MODE" == default ]] && AUDIO_DEVICE=default || AUDIO_DEVICE=$AUDIO_MODE
          shift
        else
          AUDIO_MODE=default
        fi
        ;;
      --audio=*) AUDIO_MODE=${1#*=}; [[ "$AUDIO_MODE" == default ]] && AUDIO_DEVICE=default || AUDIO_DEVICE=$AUDIO_MODE ;;
      -o|--output) (($# >= 2)) || die "$1 requires a value"; OUTPUT=$2; shift ;;
      --output=*) OUTPUT=${1#*=} ;;
      --dir) (($# >= 2)) || die "$1 requires a value"; OUTPUT_DIR=$2; shift ;;
      --dir=*) OUTPUT_DIR=${1#*=} ;;
      -p|--open) OPEN_AFTER=true ;;
      --force) FORCE=true ;;
      --no-cursor) NO_CURSOR=true ;;
      -h|--help) usage; exit 0 ;;
      -*) die "Unknown option: $1" ;;
      *) [[ -z "$OUTPUT" ]] || die "Unexpected argument: $1"; OUTPUT=$1 ;;
    esac
    shift
  done
  [[ "$SOURCE" == full || "$SOURCE" == region ]] || die "Source must be full or region."
  [[ "$AUDIO_MODE" == none || "$AUDIO_MODE" == default || -n "$AUDIO_MODE" ]] || die 'Invalid audio source.'
  [[ "$FPS" =~ ^[1-9][0-9]*$ ]] || die 'FPS must be a positive integer.'
}

main() {
  local command=${1:-}
  if [[ -z "$command" ]]; then
    INTERACTIVE=true
    command=start
  elif [[ "$command" != start && "$command" != stop && "$command" != status && "$command" != open && "$command" != help && "$command" == -* ]]; then
    command=start
  else
    shift
  fi

  case "$command" in
    start)
      if [[ "$INTERACTIVE" == true ]]; then
        interactive_setup
      else
        parse_start_options "$@"
      fi
      start_recording
      ;;
    stop) (($# == 0)) || die 'stop takes no options'; stop_recording ;;
    status) (($# == 0)) || die 'status takes no options'; status_recording ;;
    open) (($# <= 1)) || die 'open accepts at most one file'; open_recording "${1:-latest}" ;;
    help|-h|--help) usage ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"
