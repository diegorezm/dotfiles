#!/usr/bin/env bash
set -euo pipefail

# --- defaults ---
FPS=30
OUTPUT_DIR="$HOME/vids/recordings"
REGION=false
PREVIEW=false
AUDIO=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] [output_file]
Options:
  -r            Record a region instead of the full screen (requires slurp)
  -f FPS        Max framerate (default: $FPS)
  -o DIR        Output directory (default: $OUTPUT_DIR)
  -a            Record audio (default PipeWire/pulse device)
  -p            Open the recording in mpv when done
  -h            Show this help

Session type is auto-detected. On X11, requires slop for region selection.
If no output file is given, a timestamped filename is used.
EOF
  exit 0
}

# --- parse args ---
while getopts ":rf:o:aph" opt; do
  case $opt in
    r) REGION=true ;;
    f) FPS="$OPTARG" ;;
    o) OUTPUT_DIR="$OPTARG" ;;
    a) AUDIO=true ;;
    p) PREVIEW=true ;;
    h) usage ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    \?) echo "Unknown option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT="${1:-$OUTPUT_DIR/rec_$TIMESTAMP.mp4}"

# --- detect session type ---
SESSION_TYPE="${XDG_SESSION_TYPE:-}"
if [[ -z "$SESSION_TYPE" ]]; then
  [[ -n "${WAYLAND_DISPLAY:-}" ]] && SESSION_TYPE="wayland" || SESSION_TYPE="x11"
fi

# ============================================================
# WAYLAND PATH — wl-screenrec
# ============================================================
if [[ "$SESSION_TYPE" == "wayland" ]]; then
  if ! command -v wl-screenrec &>/dev/null; then
    echo "Error: 'wl-screenrec' is required for Wayland recording." >&2
    echo "  cargo install wl-screenrec  OR  check your distro packages" >&2
    exit 1
  fi

  ARGS=(
    --filename "$OUTPUT"
    --max-fps "$FPS"
    --ffmpeg-encoder libx264
    --encode-pixfmt yuv420p
    --ffmpeg-encoder-options "preset=ultrafast,crf=23"
  )

  if $REGION; then
    if ! command -v slurp &>/dev/null; then
      echo "Error: 'slurp' is required for region selection on Wayland." >&2
      echo "  sudo zypper install slurp" >&2
      exit 1
    fi
    echo "Select a region on screen..."
    GEOM=$(slurp)
    ARGS+=(--geometry "$GEOM")
  fi

  $AUDIO && ARGS+=(--audio)

  echo "Recording at ${FPS}fps → $OUTPUT"
  echo "Press Ctrl+C to stop."

  WL_PID=""
  cleanup_wayland() {
    echo
    [[ -n "$WL_PID" ]] && kill -INT "$WL_PID" 2>/dev/null || true
    wait "$WL_PID" 2>/dev/null || true
  }
  trap cleanup_wayland INT TERM

  wl-screenrec "${ARGS[@]}" &
  WL_PID=$!
  wait "$WL_PID" || true

# ============================================================
# X11 PATH — ffmpeg x11grab
# ============================================================
else
  if $REGION; then
    if ! command -v slop &>/dev/null; then
      echo "Error: 'slop' is required for region selection on X11." >&2
      echo "  sudo zypper install slop" >&2
      exit 1
    fi
    echo "Select a region on screen..."
    GEOM=$(slop -f "%wx%h+%x+%y")
    SIZE="${GEOM%%+*}"
    OFFSET="+${GEOM#*+}"
  else
    if command -v xdpyinfo &>/dev/null; then
      SIZE=$(xdpyinfo | awk '/dimensions/{print $2}')
    else
      SIZE="1920x1080"
      echo "Warning: xdpyinfo not found, defaulting to ${SIZE}."
    fi
    OFFSET="+0,0"
  fi

  echo "Recording ${SIZE} at ${FPS}fps → $OUTPUT"
  echo "Press Ctrl+C to stop cleanly."

  FIFO=$(mktemp -u /tmp/screenrec_fifo_XXXXXX)
  mkfifo "$FIFO"
  exec 3<>"$FIFO"
  rm "$FIFO"

  FFMPEG_PID=""
  cleanup_x11() {
    echo
    if [[ -n "$FFMPEG_PID" ]]; then
      echo "q" >&3
      wait "$FFMPEG_PID" 2>/dev/null || true
    fi
    exec 3>&-
  }
  trap cleanup_x11 INT TERM

  ffmpeg -hide_banner -loglevel warning \
    -f x11grab \
    -framerate "$FPS" \
    -video_size "$SIZE" \
    -i "${DISPLAY}${OFFSET}" \
    -c:v libx264 \
    -preset ultrafast \
    -crf 23 \
    -pix_fmt yuv420p \
    "$OUTPUT" \
    <&3 &
  FFMPEG_PID=$!
  wait "$FFMPEG_PID" || true
  exec 3>&-
fi

echo "Saved to $OUTPUT"

if $PREVIEW; then
  if ! command -v mpv &>/dev/null; then
    echo "Warning: mpv not found. Install it with: sudo zypper install mpv"
  else
    mpv "$OUTPUT"
  fi
fi
