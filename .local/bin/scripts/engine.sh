#!/bin/bash 
declare op=("  Google
󰗃  Youtube
  9anime
")

search=$(echo -e "${op[@]}" |  dmenu | xargs)
case "${search#* }" in
    Google)
    # https://www.google.com/search?q=
      s=$(dmenu -p "O que procura em ${search#* }:") &&  $BROWSER "https://www.google.com/search?q=$s"

      ;;
    Youtube)
      # https://www.youtube.com/results?search_query=
      s=$( dmenu -p "O que procura em ${search#* }:") && $BROWSER "https://www.youtube.com/results?search_query=$s"
      ;;
    9anime)
  # https://9anime.gs/filter?keyword=
      s=$( dmenu -p "O que procura em ${search#* }:") &&  $BROWSER "https://9anime.gs/filter?keyword=$s"
      ;;
    *)
      exit
      ;;
esac
