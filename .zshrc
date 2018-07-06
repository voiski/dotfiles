#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
source $HOME/.dotfiles/aliases.zsh
if [[ -s "$HOME/.dotfiles/dotfilesconfidential/aliases.zsh" ]]; then
  source $HOME/.dotfiles/dotfilesconfidential/aliases.zsh # no public backup
fi

export GOPATH=$(go env GOPATH)
eval "$(rbenv init -)"