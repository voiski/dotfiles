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
export GO111MODULE=on
export EDITOR=vi

eval "$(rbenv init -)"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Terraform version
load-tfswitch() {
  local tfswitchrc_path=".tfswitchrc"

  if [ -f "$tfswitchrc_path" ]; then
    tfswitch
  fi
}
add-zsh-hook chpwd load-tfswitch
load-tfswitch

# Dot envs
load-dotenv() {
  if [ -f ".envrc" ]; then
    echo "Loading .envrc"
    export $(grep -v '^#' .envrc | xargs -0)
  elif [ -f ".env" ]; then
    echo "Loading .env"
    export $(grep -v '^#' .env | xargs -0)
  fi
}
add-zsh-hook chpwd load-dotenv
load-dotenv