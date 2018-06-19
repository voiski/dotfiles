#!/bin/bash -e
BASE="${HOME}/Library/Application Support/Sublime Text 3"
PACKAGES="${BASE}/Installed Packages"
SETTINGS="${BASE}/Packages/User"

mkdir -p $PACKAGES
wget https://packagecontrol.io/Package%20Control.sublime-package -P ${PACKAGES}

mkdir -p $SETTINGS
rm -Rf $SETTINGS
ln -s "${HOME}/.dotfiles/sublime/User" $SETTINGS
