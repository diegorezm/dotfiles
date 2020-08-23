#!/bin/bash 

mpd_display() {
        get_mpd=$(mpc status | grep playing)
        mus=$(mpc current | cut -f1 -d "." | head -c 50)
        [ -z $get_mpd ] && echo "" || echo " $mus"
}
mpd_display

