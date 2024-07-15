#!/bin/bash 
pjrs=$(tmux ls | awk '{print $1}' | sed 's/:/''/g' | dmenu -p "Choose one: " -l 10)

if [[ -z $pjrs ]]; then
  exit 
else
  $TERMINAL -e tmux a -t $pjrs
fi

