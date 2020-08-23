#!/bin/bash

mus=$(mpc current)  
if [[ -z $mus ]]; then
        echo "Paused"

else 
        echo "$mus"
fi
