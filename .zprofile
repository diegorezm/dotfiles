export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')"
export PATH="$PATH:$HOME/.local/bin/scripts"
export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/java/lombok.jar"

# Programs
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"
export READER="zathura"
export SCRIPTS_DIR=$HOME/.local/bin/scripts
export npm_config_prefix="$HOME/.local"
