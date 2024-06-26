#!/bin/bash 

declare option=("󰀼  vifm
  alacritty
󰄛  kitty
  zsh
  dwm
  xresources
  qtile
  rofi
  nvim")


esc=$(echo -e "${option[@]}" | dmenu -p 'Choose one:' | xargs)

if [[ "$esc" == *"dwm"* ]]; then
  $TERMINAL --working-directory="$HOME/.config/dwm" && exit 0
fi

case "${esc#* }" in
        vifm)
                esc="$HOME/.config/vifm/vifmrc"
        ;;
        xresources)
                esc="$HOME/.config/Xresources"
        ;;
        zsh)
                esc="$HOME/.zshrc"
        ;;
        qtile)
                esc="$HOME/.config/qtile"
        ;;
        nvim)
                esc="$HOME/.config/nvim/"
        ;;
        alacritty)
                esc="$HOME/.config/alacritty"
        ;;
        rofi)
                esc="$HOME/.local/share/rofi/"
        ;;
        kitty)
                esc="$HOME/.config/kitty/kitty.conf"
        ;;
        *)
                exit 0
        ;;
esac

$TERMINAL -e nvim $esc
