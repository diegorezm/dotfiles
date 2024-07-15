#!/bin/bash 

declare options=("⏻ Shutdown
 Reboot
 Lock")

chs=$(echo -e "${options[@]}" | dmenu -p "What do you want to do?")
case "${chs#* }" in 
        Shutdown)
                poweroff
        ;;
        Reboot)
                reboot
        ;;
        Lock)
                screenlock -w
        ;;
        *)
                exit 0
        ;;
esac


