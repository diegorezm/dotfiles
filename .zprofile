export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')"
export PATH="$PATH:$HOME/.local/bin/scripts"
export PATH="$PATH:$HOME/.dotnet/tools/"
export PATH="$PATH:$HOME/.config/emacs/bin"

export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/java/lombok.jar"
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export ANDROID_HOME="$HOME/Android/Sdk"
export AMD_VULKAN_ICD=RADV

# Programs
export EDITOR="nvim"
export TERMINAL="kitty"
export VISUAL=/bin/nvim
export BROWSER="zen-browser"
export READER="zathura"
export SCRIPTS_DIR=$HOME/.local/bin/scripts
export npm_config_prefix="$HOME/.local"

