#!/bin/bash 

declare options=("Shutdown
Reboot
Hibernate")

chs=$(echo -e "${options[@]}" | dmenu -p "Choose one:")
case "$chs" in 
        Shutdown)
                systemctl poweroff
                ;;
        Reboot)
                systemctl reboot
        ;;
        Hibernate)
                systemctl hibernate
        ;;
        *)
                exit 0
        ;;
esac


