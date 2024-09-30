#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

lxsession & 
#redshift -l -22.905843:-47.052617  -P -O 2400 &
xset r rate 300 50 &
$HOME/.local/bin/scripts/screen.sh
# $HOME/.local/bin/scripts/changer
$HOME/.fehbg 
discord &
dwmblocks &
picom &
xrdb -merge ~/.config/Xresources/Xresources
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
wmname LG3D
exec dwm
