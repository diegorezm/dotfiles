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
ln -s $CURRENT_DIR/.zshrc  $HOME/.zshrc
ln -s $CURRENT_DIR/.zprofile  $HOME/.zprofile
ln -s $CURRENT_DIR/.tmux.conf  $HOME/.tmux.conf
ln -s $CURRENT_DIR/.xinitrc  $HOME/.xinitrc
ln -s $CURRENT_DIR/wallpapers $HOME/img/wallpapers
ln -s $CURRENT_DIR/.config/nvim  $HOME/.config/nvim
ln -s $CURRENT_DIR/.config/alacritty  $HOME/.config/alacritty
ln -s $CURRENT_DIR/.config/nvim  $HOME/.config/nvim
ln -s $CURRENT_DIR/.local/bin/scripts $HOME/.local/bin/scripts
ln -s $CURRENT_DIR/.config/nvim  $HOME/.config/nvim
ln -s $CURRENT_DIR/.config/qtile  $HOME/.config/qtile
ln -s $CURRENT_DIR/.config/mpd  $HOME/.config/mpd
ln -s $CURRENT_DIR/.config/ncmpcpp  $HOME/.config/ncmpcpp
ln -s $CURRENT_DIR/.config/zathura  $HOME/.config/zathura
ln -s $CURRENT_DIR/.config/dunst  $HOME/.config/dunst
ln -s $CURRENT_DIR/.config/yazi  $HOME/.config/yazi
ln -s $CURRENT_DIR/.config/kitty  $HOME/.config/kitty
ln -s $CURRENT_DIR/.config/Xresources  $HOME/.config/Xresources
ln -s $CURRENT_DIR/.config/xmonad  $HOME/.config/xmonad
ln -s $CURRENT_DIR/.config/xmobar  $HOME/.config/xmobar

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
