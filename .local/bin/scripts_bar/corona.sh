#!/bin/bash 
[ "$(stat -c  %y  ~/.cache/corona | cut -d' ' -f1)" != $(date '+%Y-%m-%d') ] &&  curl  https://corona-stats.online/br > ~/.cache/corona
cat ~/.cache/corona | grep Brazil | sed "s/\s*//g ; s/║//g ; s/│/;/g"  | awk -F';' '{print $3 "/" $5 }'

