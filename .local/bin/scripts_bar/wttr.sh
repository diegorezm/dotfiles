#!/bin/bash 
[ $(stat -c  %y  ~/.cache/wheater | awk -F'.' '{print $1}' | awk '{print $2}') != $(date '+%H:%M:%s') ] && curl -s "wttr.in?format=1" > ~/.cache/wheater 

temp () {
        _w=$(cat ~/.cache/wheater | awk -F '+' '{print $2}')
        echo "  $_w "
}
temp
