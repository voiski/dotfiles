path=(
# Load Node global installed binaries
$HOME/.node/bin:$PATH

# Node yarn modules
$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH

# Use project specific binaries before global ones
node_modules/.bin:vendor/bin:$PATH

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
#  $(brew --prefix coreutils)/libexec/gnubin:$PATH

# Local bin directories before anything else
/usr/local/bin:/usr/local/sbin:$PATH

# Load custom commands
# Disabled this because I have no custom binaries at the moment.
$DOTFILES/bin:$PATH

# Load golang global installed binaries
$HOME/go/bin:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
$HOME/.rvm/bin

# Always keep path here
$path
)

#################################
# Mac only
if [[ "$OSTYPE" == "darwin"* ]]; then
	return;
fi

#################################
# Linux
path=(
# Map brew for linux
/home/linuxbrew/.linuxbrew/bin
$path
)