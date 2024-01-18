#!/bin/bash 
declare option=("  .local
  download
  images
  Xresources
  docs 
  videos 
  code
  music
  bin
  share")
esc=$(echo -e "${option[@]}" | dmenu  -p "Choose one:" | xargs)
echo "${esc#* }" 
case "${esc#* }" in
        docs)
                esc="$HOME/docs"
        ;;
        .local)
                esc="$HOME/.local"
        ;;
        videos)
                esc="$HOME/vids"
        ;;
        download)
                esc="$HOME/down"
        ;;
        images)
                esc="$HOME/img"
        ;;
        code)
              dir=$(ls -D "$HOME/docs/code" | dmenu -p "Choose one:")
              esc="$HOME/docs/code/$dir"
        ;;
        music)
                esc="$HOME/msc"
        ;;
        bin)
                esc="$HOME/.local/bin"
        ;;
        share)
                esc="$HOME/.local/share"
        ;;
        Xresources)
                esc="$HOME/.config/Xresources"
        ;;
        *)
                exit 0 
        ;;
esac

case $TERMINAL in
  st)
    $TERMINAL -d $esc
  ;;
  kitty)
    $TERMINAL --working-directory=$esc
  ;;
  *)
    $TERMINAL --working-directory=$esc
  ;;
    
esac
