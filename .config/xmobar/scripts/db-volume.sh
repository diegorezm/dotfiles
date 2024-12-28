#!/bin/bash 
# from https://github.com/LukeSmithxyz/voidrice/blob/master/.local/bin/statusbar/sb-volume
vol="$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')"

# If muted, print 🔇 and exit.
[ "$vol" != "${vol%\[MUTED\]}" ] && echo 🔇 && exit

# Remove any decimal part by extracting the integer part of the volume
vol="${vol%.*}"

case 1 in
	$((vol >= 70)) ) icon="🔊" ;;
	$((vol >= 30)) ) icon="🔉" ;;
	$((vol >= 1)) ) icon="🔈" ;;
	* ) echo 🔇 && exit ;;
esac

echo "^c#ea76cb^"$icon $vol%"^d^"

