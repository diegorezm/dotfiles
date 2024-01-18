#!/bin/bash 
playlist=$(mpc playlist -f '%position% %file%' |   dmenu -l 10 -p 'Songs:'  | awk '{print $1}' ) 
mpc play "$playlist"  && mp_notify
