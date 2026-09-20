#!/bin/sh

choice=$(
	printf '%s\n' \
		'Downloads' \
		'Code' \
		'Documents' \
		'Images' \
		'Videos' \
		'Music' \
		'.local' \
		'Scripts' \
		'Bin' \
		'Share' |
		noctalia dmenu -p 'Open directory'
) || exit 0

case "$choice" in
	Downloads) target="$HOME/down" ;;
	Documents) target="$HOME/docs" ;;
	Images) target="$HOME/img" ;;
	Videos) target="$HOME/vids" ;;
	Music) target="$HOME/msc" ;;
	.local) target="$HOME/.local" ;;
	Scripts) target="$HOME/.local/bin/scripts" ;;
	Bin) target="$HOME/.local/bin" ;;
	Share) target="$HOME/.local/share" ;;
	Code)
		target=$(
			find "$HOME/code" -mindepth 1 -maxdepth 1 -type d -print |
				sort |
				noctalia dmenu -p 'Open project'
		) || exit 0
		;;
	*) exit 1 ;;
esac

[ -d "$target" ] || exit 1

case "${TERMINAL:-alacritty}" in
	*alacritty*) alacritty --working-directory "$target" ;;
	*) "${TERMINAL:-alacritty}" -d "$target" ;;
esac
