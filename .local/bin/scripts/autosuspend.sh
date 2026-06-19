#!/bin/bash

# ─────────────────────────────────────────────
# Autosuspend
# ─────────────────────────────────────────────
# Dependencies: xprintidle, xset, pactl, systemctl
#
# Manual inhibit: touch /tmp/no-suspend
# Remove inhibit: rm /tmp/no-suspend
# ─────────────────────────────────────────────

# -- defaults --
IDLE_THRESHOLD=300000
CHECK_INTERVAL=60
NET_THRESHOLD=100
IFACE=$(ip -o route get 1 | awk '{print $5}')
INHIBIT_FILE=/tmp/no-suspend

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Auto-suspends the system when idle, unless something is still happening.

Options:
  --idle-threshold MS     Milliseconds of idle time before suspending (default: 300000 = 5 min)
  --check-interval SEC    Seconds between each idle check (default: 60)
  --net-threshold KB      KB/s above which a download is considered active (default: 100)
  --iface NAME            Network interface to monitor (default: auto-detected)
  --inhibit-file PATH     Path to the inhibit flag file (default: /tmp/no-suspend)
  -h, --help              Show this help message

Examples:
  $(basename "$0") --idle-threshold 600000 --check-interval 30
  $(basename "$0") --iface eth0 --net-threshold 50

Manual inhibit:
  touch /tmp/no-suspend   # prevent suspend indefinitely
  rm /tmp/no-suspend      # re-enable suspend
EOF
}

# -- parse arguments --
while [[ $# -gt 0 ]]; do
    case "$1" in
        --idle-threshold)
            IDLE_THRESHOLD="$2"; shift 2 ;;
        --check-interval)
            CHECK_INTERVAL="$2"; shift 2 ;;
        --net-threshold)
            NET_THRESHOLD="$2"; shift 2 ;;
        --iface)
            IFACE="$2"; shift 2 ;;
        --inhibit-file)
            INHIBIT_FILE="$2"; shift 2 ;;
        -h|--help)
            usage; exit 0 ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1 ;;
    esac
done

# ─────────────────────────────────────────────

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $*"
}

is_inhibited() {
    [ -f "$INHIBIT_FILE" ]
}

is_ssh_active() {
    who | grep -q "pts/"
}

get_rx_bytes() {
    cat "/sys/class/net/$IFACE/statistics/rx_bytes"
}

is_downloading() {
    local before after speed
    before=$(get_rx_bytes)
    sleep 3
    after=$(get_rx_bytes)
    speed=$(( (after - before) / 3 / 1024 ))
    [ "$speed" -ge "$NET_THRESHOLD" ]
}

is_audio_playing() {
    pactl list sinks | grep -q "State: RUNNING"
}

should_skip_suspend() {
    if is_audio_playing; then
        log "audio playing, skipping suspend."
        return 0
    fi
    if is_inhibited; then
        log "inhibit file present ($INHIBIT_FILE), skipping suspend."
        return 0
    fi
    if is_ssh_active; then
        log "SSH session active, skipping suspend."
        return 0
    fi
    if is_downloading; then
        log "download in progress ($IFACE), skipping suspend."
        return 0
    fi
    return 1
}

log "idle-suspend started (threshold: ${IDLE_THRESHOLD}ms, interval: ${CHECK_INTERVAL}s, iface: $IFACE)"

while true; do
    idle=$(xprintidle)

    if [ "$idle" -ge "$IDLE_THRESHOLD" ]; then
        if should_skip_suspend; then
            :
        else
            log "idle threshold reached, suspending."
            xset dpms force off
            sleep 2
            systemctl suspend
        fi
    fi

    sleep "$CHECK_INTERVAL"
done
