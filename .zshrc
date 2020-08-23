#       Path
export PATH=$PATH:~/.npm/apps/bin
export PATH=$PATH:~/go/bin/
export PATH=$PATH:~/.local/bin/

#       General conf
stty stop undef
autoload -U colors && colors

export EDITOR=/bin/nvim
export VISUAL=/bin/nvim

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history
setopt correctall
unsetopt correct_all

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats 'on branch %b'

#        PROMPT
PROMPT='%B%F{139}[%0~]%f%b%F{2}$ '
# PROMPT='%B%F{139}%f%b%F{2}$ '


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
alias p="sudo pacman"
alias pp="pacman -Ss"
alias pi="sudo pacman -S"
alias pu="sudo pacman -Syu"
alias ap="sudo apt"
alias aps="apt search"
alias ra="ranger"
alias grep="grep --color=auto"
alias vf="vifm"
alias sxiv="sxiv -b"
alias xd="xrdb -merge ~/.config/Xresources"
alias n="nvim"
alias ms="ncmpcpp"
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME/'
alias yt-audio="youtube-dl -x -i -f bestaudio/best"
alias l="exa -al --color=always --group-directories-first"
alias ls="exa -a --color=always --group-directories-first"
alias cp="cp -i"
alias dcompile="sudo make clean install"
alias commit="git commit -m"
alias push="git push origin"

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
bindkey -s '^f' 'nvim $(find ~/.local/bin/ -type f | fzf)\n'
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

#       source 
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
