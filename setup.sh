#!/bin/bash 

CURRENT_DIR=$(pwd)

# Install all pkgs
# pacman -S - < pkglist.txt

if [[ ! -d $HOME/.config ]]; then
  mkdir $HOME/.config/
fi

ln -s $CURRENT_DIR/.zshrc  $HOME/.zshrc
ln -s $CURRENT_DIR/.zprofile  $HOME/.zprofile
ln -s $CURRENT_DIR/.xinitrc  $HOME/.xinitrc
ln -s $CURRENT_DIR/.config/nvim  $HOME/.config/nvim
ln -s $CURRENT_DIR/.config/nvim  $HOME/.config/nvim
ln -s $CURRENT_DIR/.local/bin/scripts $HOME/.local/bin/scripts
ln -s $CURRENT_DIR/.config/nvim  $HOME/.config/nvim
ln -s $CURRENT_DIR/.config/qtile  $HOME/.config/qtile
ln -s $CURRENT_DIR/.config/mpd  $HOME/.config/mpd
ln -s $CURRENT_DIR/.config/ncmpcpp  $HOME/.config/ncmpcpp
ln -s $CURRENT_DIR/.config/zathura  $HOME/.config/zathura
ln -s $CURRENT_DIR/.config/dunst  $HOME/.config/dunst
ln -s $CURRENT_DIR/.config/settings.json  $HOME/.config/Code/User/settings.json
