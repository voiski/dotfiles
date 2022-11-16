path=(
# My dots
$HOME/.dotfiles/bin

# Ruby
$HOME/.gem/bin

# ASDF shims
$HOME/.asdf/shims

# Load Node global installed binaries
$HOME/.node/bin

# Node yarn modules
$HOME/.yarn/bin
$HOME/.config/yarn/global/node_modules/.bin

# Use project specific binaries before global ones
node_modules/.bin
vendor/bin

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
#  $(brew --prefix coreutils)/libexec/gnubin

# Load golang global installed binaries
$HOME/go/bin

# rancher bin - includes docker
$HOME/.rd/bin

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
