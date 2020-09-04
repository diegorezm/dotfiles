#!/bin/bash 

declare option=("I3
vifm
dwm-d
st-d
zsh
xresources
qtile
dunst
nvim
polybar
openbox")

esc=$(echo -e "${option[@]}" | dmenu -p 'Choose one:')

case "$esc" in
        I3)
                esc="$HOME/.config/i3/config"
        ;;
        vifm)
                esc="$HOME/.config/vifm/vifmrc"
        ;;
        dwm-d)
                esc="$HOME/.config/dwm-d/"
        ;;
        st-d)
                esc="$HOME/.config/st-d/config.h"
        ;;
        xresources)
                esc="$HOME/.config/Xresources"
        ;;
        zsh)
                esc="$HOME/.config/zsh/.zshrc"
        ;;
        qtile)
                esc="$HOME/.config/qtile/config.py"
        ;;
        dunst)
                esc="$HOME/.config/dunst/dunstrc"
        ;;
        nvim)
                esc="$HOME/.config/nvim/init.vim"
        ;;
        polybar)
                esc="$HOME/.config/polybar/config"
        ;;
        openbox)
                esc="$HOME/.config/openbox/rc.xml"
        ;;
        *)
                exit 0
        ;;
esac

st -e nvim $esc
