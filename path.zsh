# Load Node global installed binaries
export PATH="$HOME/.node/bin:$PATH"

# Node yarn modules
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Use project specific binaries before global ones
export PATH="node_modules/.bin:vendor/bin:$PATH"

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
#export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Local bin directories before anything else
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Load custom commands
# Disabled this because I have no custom binaries at the moment.
export PATH="$DOTFILES/bin:$PATH"

# Load golang global installed binaries
export PATH="$HOME/go/bin:$PATH"

#################################
# Linux
if [[ "$OSTYPE" == "darwin"* ]]; then return; fi

# Map brew for linux
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"