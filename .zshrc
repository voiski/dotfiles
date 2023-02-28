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
source $HOME/.dotfiles/path.zsh
source $HOME/.dotfiles/hooks.zsh
source $HOME/.dotfiles/aliases.zsh
if [[ -s "$HOME/.dotfiles/dotfilesconfidential/aliases.zsh" ]]; then
  source $HOME/.dotfiles/dotfilesconfidential/aliases.zsh # no public backup
fi

# Session Envs
export VISUAL='subl -w'
export EDITOR=vi

export GOPATH=$(go env GOPATH)
export GO111MODULE=on
export DOCKER_HOST=unix:///Users/alan.voiski/.colima/docker.sock

# source /Users/alan.voiski/.rvm/scripts/rvm
. $(brew --prefix)/opt/asdf/libexec/asdf.sh
