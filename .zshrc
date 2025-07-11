if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  startx
fi

source $HOME/.env
#
#       General conf
$SCRIPTS_DIR/ufetch stty stop undef
autoload -U colors && colors

#       Reminder
# reminder-cli list notifications

#       Editor config
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
#
# Load vcs (version control system)
autoload -Uz vcs_info
precmd() { vcs_info }
# show the branch
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
# PROMPT='%F{green}%T%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
PROMPT=' %F{green}%~%f %F{red}${vcs_info_msg_0_}%f$ '

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
alias zathura="devour zathura"
alias mpv="devour mpv"
alias grep="grep --color=auto"
alias vf="vifm"
alias sxiv="sxiv -b"
alias genpsw="head -c 16 /dev/random | od -A n -t x1 | sed 's/[[:space:]]//g'"
alias xd="xrdb -merge $HOME/.config/Xresources/Xresources"
alias n="nvim"
alias ms="ncmpcpp"
alias fmrecord="ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -s 1920x1080 -i :0.0+0,0 -c:v libx264 -preset ultrafast"

alias fmrecord_w="ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :0.0+0,0 \
-c:v libx264 -preset ultrafast -tune zerolatency -pix_fmt yuv420p -crf 23 \
-movflags +faststart"

alias fmrecordsm="ffmpeg -video_size 1366x768 -framerate 30 -f x11grab -i :0.0+204,1080 -c:v libx264 -preset ultrafast"
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME/'
alias yt-audio="yt-dlp --add-metadata -x -i -f bestaudio"
alias yt-video="yt-dlp --add-metadata -i -f best/video"
alias l="exa -al --color=always --group-directories-first"
alias ls="exa -a --color=always --group-directories-first"
alias sl="exa -a --color=always --group-directories-first"
alias cp="cp -i"
alias dcompile="sudo make clean install"
alias gitconf="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias rmt_server="/opt/urserver/urserver --daemon"

#       laravel alias
alias a="php artisan"
alias mfs="php artisan migrate:fresh --seed"

#       git alias
alias g="git"
alias ga="git add"
alias gc="git commit"
alias gac="git add . && git commit -m"
alias gp="git push"
alias gl="git pull"
alias wip="git add . && git commit -m 'wip'"

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

bindkey -s '^f' 'cd $(find ~/.local/bin/ ~/code/ -type d -not -path "*/node_modules/*" -not -path "*/vendor/*" -not -path "*/.git/*" | fzf)\n'
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

#       source 
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

NPM_PACKAGES="${HOME}/.local/pkg/"
export PATH="$PATH:$NPM_PACKAGES/bin"
export PATH="$PATH:$HOME/.fly/bin"
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

# pnpm
export PNPM_HOME="/home/diego/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
