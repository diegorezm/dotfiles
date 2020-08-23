#!/bin/bash 

son(){
        get_sound=$(amixer sget Master | grep "Right:" | awk -F'[][]' '{print $2}')
        echo " $get_sound "
}
son

