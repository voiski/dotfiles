#!/bin/sh

echo "Setting up your Mac..."

echo "Is it a personal machine? [yes,no]"
read -r personal_laptop
if [ "${personal_laptop}" = "yes" ];then
  touch ${HOME}/.personal_laptop
else
  echo "You asnwered \"${personal_laptop}\", not personal computer. Are you sure? (ctrl+c if not)"
  read -r
fi

# Check for Homebrew and install if we don't have it
if test ! "$(which brew)"; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# link go default location
ln -s $(brew --prefix golang) ${HOME}/go

# Make ZSH the default shell environment
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)

# Extra completions
curl -fLo ~/.zprezto/modules/completion/external/src/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
compinit

# Install global NPM packages
npm install --global yarn

# ZSH - Prezto =D
# http://sourabhbajaj.com/mac-setup/iTerm/zsh.html
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/z*; do
  ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Removes .zs? from $HOME (if it exists) and symlinks the .zshrc/.zpreztorc file from the .dotfiles
rm -rf $HOME/.zshrc $HOME/.zpreztorc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
ln -s $HOME/.dotfiles/.zpreztorc $HOME/.zpreztorc

# Restore sublime
ln -s $HOME/.dotfiles/.sublime/User $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Symlink the git config file to the home directory
rm -f $HOME/.gitconfig $HOME/.gitignore_global
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

if ! [ -f ~/.ssh/id_ed25519 ];then
  echo "Enter email for its ssh key"
  read -s target_email
  echo "Generating new ssh key"
  ssh-keygen -t ed25519 -C ${target_email}
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  cat >> ~/.ssh/config <<-EOF
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF

fi

# TODO: Configure istio brew keg
# Install istio
# curl -L https://git.io/getLatestIstio | sh -
# istio_base_path=$(find . -type dir -maxdepth 1 -name 'istio-*' | xargs basename)
# ln -s $HOME/.dotfiles/${istio_base_path}/bin/istioctl /usr/local/bin/istioctl

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos

# link confidential
if [[ -s "dotfilesconfidential/install.sh" ]]; then
  exec dotfilesconfidential/install.sh
fi
