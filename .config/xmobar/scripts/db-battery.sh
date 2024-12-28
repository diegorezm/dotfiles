#!/bin/bash 
declare -a icons=('󰂄' '󰂂' '󰂀' '󰁽' '󰁻')
declare -a colors=('#a6e3a1' '#74c7ec' '#fab387' '#dd7878')
chargin=$(cat /sys/class/power_supply/BAT0/uevent | grep 'POWER_SUPPLY_STATUS' | sed 's/=/ /g'| awk '{print $2}')
battery=$(cat /sys/class/power_supply/BAT0/capacity)
icon=""
color=""

if [[ $chargin == 'Charging' ]]; then
  icon=${icons[0]}
else 
  case 1 in 
    $(( $battery >= 80 )) ) 
      icon=${icons[1]} 
      color=${colors[0]}
      ;;
    $(( $battery >= 40 )) ) 
      icon=${icons[2]} 
      color=${colors[1]}
      ;;
    $(( $battery >= 20)) ) 
      icon=${icons[3]} 
      color=${colors[2]}
      ;;
    $(( $battery >= 1 )) ) 
      icon=${icons[4]} 
      color=${colors[3]}
      ;;
    *) 
      echo "${icons[4]} $battery%"&& exit 
      ;;
  esac
fi

echo  $icon $battery% 
