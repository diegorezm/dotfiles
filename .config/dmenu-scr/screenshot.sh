#!/bin/bash 

declare option=("Fullscreen
Cropped")


esc=$(echo -e "${option[@]}" | dmenu -p 'Choose one')


case "$esc" in
        Fullscreen)
                 scrot 'FULLPRINT-%Y-%d_%M-%S.png' -e 'mv $f ~/img/prints/ && sxiv ~/img/prints/$f'
        ;;
        Cropped)
                 scrot -s 'CROPPRINT-%Y-%d_%M-%S.png' -e 'mv $f ~/img/prints/ && sxiv ~/img/prints/$f'

        ;;
        *)
                exit 0
        ;;
esac
