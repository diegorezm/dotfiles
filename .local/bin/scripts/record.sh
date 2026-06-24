#!/usr/bin/env bash

set -euo pipefail

# --- defaults ---
FPS=30
OUTPUT_DIR="$HOME/vids/recordings"
REGION=false
PREVIEW=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] [output_file]

Options:
  -r            Record a region instead of the full screen (requires slop)
  -f FPS        Framerate (default: $FPS)
  -o DIR        Output directory (default: $OUTPUT_DIR)
  -p            Open the recording in mpv when done
  -h            Show this help

If no output file is given, a timestamped filename is used.
EOF
  exit 0
}

# --- parse args ---
while getopts ":rf:o:ph" opt; do
  case $opt in
    r) REGION=true ;;
    f) FPS="$OPTARG" ;;
    o) OUTPUT_DIR="$OPTARG" ;;
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

# --- get capture geometry ---
if $REGION; then
  if ! command -v slop &>/dev/null; then
    echo "Error: 'slop' is required for region selection. Install it with:"
    echo "  sudo zypper install slop"
    exit 1
  fi
  echo "Select a region on screen..."
  GEOM=$(slop -f "%wx%h+%x+%y")
  SIZE="${GEOM%%+*}"    # WxH
  OFFSET="+${GEOM#*+}" # +X,Y
else
  # full screen — detect with xdpyinfo
  if command -v xdpyinfo &>/dev/null; then
    SIZE=$(xdpyinfo | awk '/dimensions/{print $2}')
  else
    SIZE="1920x1080"
    echo "Warning: xdpyinfo not found, defaulting to ${SIZE}. Install xdpyinfo or set manually."
  fi
  OFFSET="+0,0"
fi

echo "Recording ${SIZE} at ${FPS}fps → $OUTPUT"
echo "Press q + Enter to stop cleanly."

# Use a FIFO so we can send 'q' to ffmpeg's stdin on Ctrl+C,
# letting it finalize the file instead of dying mid-write.
FIFO=$(mktemp -u /tmp/screenrec_fifo_XXXXXX)
mkfifo "$FIFO"
exec 3<>"$FIFO"
rm "$FIFO"

FFMPEG_PID=""

cleanup() {
  echo
  if [[ -n "$FFMPEG_PID" ]]; then
    echo "q" >&3
    wait "$FFMPEG_PID" 2>/dev/null || true
  fi
  exec 3>&-
}

trap cleanup INT TERM

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

echo "Saved to $OUTPUT"

if $PREVIEW; then
  if ! command -v mpv &>/dev/null; then
    echo "Warning: mpv not found. Install it with: sudo zypper install mpv"
  else
    mpv "$OUTPUT"
  fi
fi
