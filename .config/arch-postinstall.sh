#!/bin/sh 

getconfig(){
        cd $HOME/dotfiles
        mv .config/* $HOME/config/
        mv .local/bin $HOME/.local/
        mv .ncmpcpp/ $HOME/
        mv .zshrc $HOME/
        mkdir -p ~/img/prints
        mkdir -p ~/.cache/zsh
}

installdwm(){
        git clone https://github.com/diegorezm/dwm-d
        mv dwm-d $HOME/.config/
        cd $HOME/.config/dwm-d/
        sudo make clean install
        cd ..
        git clone https://github.com/torrinfail/dwmblocks
        cp blocks.h dwmblocks/blocks.h
        cd dwmblocks
        sudo make clean install
}

installpkg(){
        pkglist="arch-pkglist.txt"
        [ -f $pkglist ] &&  sudo pacman -S --needed --noconfirm - < $pkglist || echo "ERRO. The script can´t find the pkg list file."
}


helptxt(){
        echo "-h        get the help text"
        echo "-a        get all the configuration"
        echo "-d        get only the dwm configuration"
        echo "-i        get only the packages installed"
}

case "$1" in 
        -a)
                getconfig ; installdwm ; installpkg
        ;;
        -d)
                installdwm
        ;;
        -h)
                helptxt 
        ;;
        *)
                helptxt
        ;;
esac
