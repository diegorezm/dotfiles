if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

#       General conf
$SCRIPTS_DIR/ufetch
stty stop undef
autoload -U colors && colors

#       Editor config
export EDITOR=/bin/nvim
export VISUAL=/bin/nvim


HISTSIZE=1000
SAVEHIST=1000
CACHEDIR=~/.cache/zsh
HISTFILE=$CACHEDIR/history

#     Check if .cache/zsh exist
if [[ ! -d  "$CACHEDIR" ]]; then
  mkdir -p ~/.cache/zsh 
fi

setopt correctall
unsetopt correct_all


#        PROMPT
PROMPT=" %(?.%F{154}√.%F{160}? %?)%f %B%F{213}  %0~%f%b%F{154} > "

export KEYTIMEOUT=1
#       Show vim mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins 
    echo -ne "\e[5 q"
}
zle -N zle-line-init
preexec() { echo -ne '\e[5 q' ;} 


#       alias
alias ap="sudo pacman -S"
alias p="sudo pacman -Sy"
alias rp="sudo pacman -Rcs"
alias aps="pacman -Ss"
alias pu="sudo pacman -Syu"
alias android="aft-mtp-mount $HOME/docs/pendrive"
alias ssh-conn="ssh diego@192.168.10.2"
alias create_venv="pyenv exec python -m venv .venv && source .venv/bin/activate"
alias zathura="zathura"
alias mpv="mpv"
alias grep="grep --color=auto"
alias vf="vifm"
alias sxiv="sxiv -b"
alias genpsw="head -c 16 /dev/random | od -A n -t x1 | sed 's/[[:space:]]//g'"
alias xd="xrdb -merge $HOME/.config/Xresources"
alias n="nvim"
alias ms="ncmpcpp"
alias fmrecord="ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -s 1920x1080 -i :0.0+0,0 -c:v libx264 -preset ultrafast output.mp4"
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME/'
alias yt-audio="yt-dlp --add-metadata -x -i -f bestaudio"
alias yt-video="yt-dlp --add-metadata -i -f best/video"
alias l="exa -al --color=always --group-directories-first"
alias ls="exa -a --color=always --group-directories-first"
alias sl="exa -a --color=always --group-directories-first"
alias cp="cp -i"
alias live-server="live-server --browser=$BROWSER"
alias dcompile="sudo make clean install"
alias commit="git commit -m"
alias push="git push origin"
alias gitconf="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"

#       autocompletion
autoload -U compinit
zstyle ':completion:*' menu select
compinit
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

#      Keybinds
bindkey -v
[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
bindkey '^R' history-incremental-search-backward


bindkey -s '^f' 'nvim $(find ~/.local/bin/ ~/docs/code/ -type f | fzf)\n'
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


unpack () {
    if [ -f $1 ] ; then
            case $1 in
            *.tar.bz2)    tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.tar.xz)    tar xf $1      ;;
            *.bz2)        bunzip2 $1     ;;
            *.rar)        unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)        tar xvf $1     ;;
            *.tbz2)        tar xvjf $1    ;;
            *.tgz)        tar xvzf $1    ;;
            *.zip)        unzip $1       ;;
            *.Z)        uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)        echo "don't know how to extract '$1'..." ;;
            esac
    else
            echo "'$1' is not a valid file!"
    fi
 }

#       source 
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

NPM_PACKAGES="${HOME}/.local/pkg/"
export PATH="$PATH:$NPM_PACKAGES/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin/scripts/"
export PATH="$PATH:$HOME/go/bin/"
PATH="$HOME/.config/composer/vendor/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# bun completions
[ -s "/home/diego/.bun/_bun" ] && source "/home/diego/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# Load Angular CLI autocompletion.
source <(ng completion script)
