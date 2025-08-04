#!/bin/bash 

CURRENT_DIR=$(pwd)
DWM=https://github.com/diegorezm/dwm
DWM_BLOCKS=https://github.com/diegorezm/dwmblocks
DMENU=https://github.com/diegorezm/dmenu-d

# Install all pkgs
sudo pacman -S - < pkglist.txt

# create home/config
if [[ ! -d $HOME/.config ]]; then
  mkdir $HOME/.config/
fi

# create home/.local/
if [[ ! -d $HOME/.local ]]; then
  mkdir $HOME/.local/
  mkdir $HOME/.local/bin
fi

# create home/img
if [[ ! -d $HOME/img ]]; then
  mkdir $HOME/img/
fi

# install yay
if [[ ! -d $HOME/.local/pkg ]];then
  mkdir $HOME/.local/pkg
fi

git clone https://aur.archlinux.org/yay-bin.git $HOME/.local/pkg/yay-bin
cd $HOME/.local/pkg/yay-bin
makepkg -si

# Create syslinks
./create_sys_links.sh

cd $HOME/.config/
git clone $DWM
git clone $DMENU
git clone $DWM_BLOCKS

# Build and install dwm
# cd dwm
# sudo make install
# cd ..
#
# # Build and install dwmblocks
# cd dwmblocks
# sudo make install
# cd ..
#
# # Build and install dmenu
# cd dmenu
# sudo make install
# cd ..
