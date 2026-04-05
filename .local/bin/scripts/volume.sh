#!/bin/bash 

# Usage:
#   ./volume.sh --i   → increase by 5%
#   ./volume.sh --d   → decrease by 5%

CARD=0
STEP=5%

case "$1" in
  --i)
    amixer -c $CARD sset 'PCM',0 0% >/dev/null
    amixer -c $CARD sset 'PCM',1 ${STEP}+ >/dev/null
    ;;
  --d)
    amixer -c $CARD sset 'PCM',0 0% >/dev/null
    amixer -c $CARD sset 'PCM',1 ${STEP}- >/dev/null
    ;;
  *)
    echo "Usage: $0 --i | --d"
    exit 1
    ;;
esac
