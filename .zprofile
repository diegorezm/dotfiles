export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')"
epxort PATH="$PATH:$HOME/.local/bin/scripts"

# Programs
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"
export READER="zathura"
export SCRIPTS_DIR=$HOME/.local/bin/scripts
export npm_config_prefix="$HOME/.local"
