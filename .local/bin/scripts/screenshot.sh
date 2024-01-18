#!/bin/bash 

declare option=("  Fullscreen
  Cropped
󰃢  Clean")

esc=$(echo -e "${option[@]}" | dmenu -p 'Choose one:' | xargs)

case "${esc#* }" in
        Fullscreen)
                scrot 'FULLPRINT-%Y-%d_%M-%S.png' -e 'mv $f ~/img/prints/ && sxiv ~/img/prints/$f && xclip -selection clipboard -target image/png -i ~/img/prints/$f'
        ;;
        Cropped)
                scrot -s 'CROPPRINT-%Y-%d_%M-%S.png' -e 'mv $f ~/img/prints/ && sxiv ~/img/prints/$f && xclip -selection clipboard -target image/png -i ~/img/prints/$f'
        ;;
        Clean)
                rm  ~/img/prints/*
        ;;
        *)
                exit 0
        ;;
esac
