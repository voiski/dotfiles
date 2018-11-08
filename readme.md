# Voiski's Dotfiles

This is a fork of original [driesvints/dotfiles](https://github.com/driesvints/dotfiles)
that helped me to keep my mac config backup.

I'm religious keeping all my environment changes in this repo.  To help on that,
I'm also using symbolic links to keep some tool config files inside this
repository. I'm not running it every time to validate those changes. I may have
issues if I so, but it will be at least the better reference to recover my
preferences in a new environment.

A quick legend here since I'm keeping the original Dries' readme content:
* :repeat: Original Dries' sections
* :new: Mine contribution

## What Is This? :repeat:

This repository serves as my way to help me setup and maintain my Mac. It takes the effort out of installing everything manually. Everything which is needed to install my preffered setup of macOS is detailed in this readme. Feel free to explore, learn and copy parts for your own dotfiles. Enjoy! :smile:

Read the blog post: https://medium.com/@driesvints/getting-started-with-dotfiles-76bf046d035c

## A Fresh macOS Setup

### Before you re-install :repeat:

First, go through the checklist below to make sure you didn't forget anything before you wipe your hard drive.

- Did you commit and push any changes/branches to your git repositories?
- Did you remember to save all important documents from non-iCloud directories?
- Did you save all of your work from apps which aren't synced through iCloud?
- Did you remember to export important data from your local database?
- Did you update [mackup](https://github.com/lra/mackup) to the latest version and ran `mackup backup`?

### Installing macOS cleanly :repeat:

After going to our checklist above and making sure you backed everything up, we're going to cleanly install macOS with the latest release. Follow [this article](https://www.imore.com/how-do-clean-install-macos) to cleanly install the latest macOS.

### Setting up your Mac :repeat:

If you did all of the above you may now follow these install instructions to setup a new Mac.

1. Update macOS to the latest version with the App Store
2. Install Xcode from the App Store, open it and accept the license agreement
3. Install macOS Command Line Tools by running `xcode-select --install`
4. Copy your public and private SSH keys to `~/.ssh` and make sure they're set to `600`
5. Clone this repo to `~/.dotfiles`
6. Append `/usr/local/bin/zsh` to the end of your `/etc/shells` file
7. Run `install.sh` to start the installation
8. Restore preferences by running `mackup restore`
9. Restart your computer to finalize the process

Your Mac is now ready to use!

> Note: you can use a different location than `~/.dotfiles` if you want. Just make sure you also update the reference in the [`.zshrc`](./.zshrc) file.

## Your Own Dotfiles :repeat:

If you want to start with your own dotfiles from this setup, it's pretty easy to do so. First of all you'll need to fork this repo. After that you can tweak it the way you want.

Go through the [`.macos`](./.macos) file and adjust the settings to your liking. You can find much more settings at [the original script by Mathias Bynens](https://github.com/mathiasbynens/dotfiles/blob/master/.macos) and [Kevin Suttle's macOS Defaults project](https://github.com/kevinSuttle/MacOS-Defaults).

Check out the [`Brewfile`](./Brewfile) file and adjust the apps you want to install for your machine. Use [their search page](https://caskroom.github.io/search) to check if the app you want to install is available.

Check out the [`aliases.zsh`](./aliases.zsh) file and add your own aliases. If you need to tweak your `$PATH` check out the [`path.zsh`](./path.zsh) file. These files get loaded in because the `$ZSH_CUSTOM` setting points to the `.dotfiles` directory. You can adjust the [`.zshrc`](./.zshrc) file to your liking to tweak your oh-my-zsh setup. More info about how to customize oh-my-zsh can be found [here](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization).

When installing these dotfiles for the first time you'll need to backup all of your settings with Mackup. Install and backup your settings with the command below. Your settings will be synced to iCloud so you can use them to sync between computers and reinstall them when reinstalling your Mac. If you want to save your settings to a different directory or different storage than iCloud, [checkout the documentation](https://github.com/lra/mackup/blob/master/doc/README.md#storage).

```zsh
brew install mackup
mackup backup
```

You can tweak the shell theme, the Oh My Zsh settings and much more. Go through the files in this repo and tweak everything to your liking.

Enjoy your own Dotfiles!

## Confidential dotfiles :new:

Some information cannot be published to all eyes. I found an easy way to solve it with git submodules. It is straightforward, you need to configure a submodule link to a private repo of your choice(
<a href="gitlab.com"><img alt="gitlab.com" src="https://about.gitlab.com/ico/favicon.ico"  height="16" width="16"></a>,
<a href="bitbucket.org"><img alt="bitbucket.org" src="https://bitbucket.org/favicon.ico"  height="16" width="16"></a>,
<a href="github.com"><img alt="github.com" src="https://assets-cdn.github.com/favicon.ico"  height="16" width="16"></a>
). You can then put all individual files and then connect with the related resources.

First, we need to tie it together.
```bash
# if already configured
git clone --recurse-submodules git@github.com:voiski/dotfiles.git ~/.dotfile

# if you wanna configured it first time
git clone git@github.com:voiski/dotfiles.git ~/.dotfile
cd ~/.dotfile
git submodule add git@gitlab.com:voiski/dotfilesconfidential.git dotfilesconfidential
git commit -m 'Adding confidential module'
git push
```

Now, start with git config adding some custom attributes inside your private repo. Then, you need to link it inside the [.gitconfig](.gitconfig):
```bash
[include]
	path = ~/.dotfiles/dotfilesconfidential/.gitconfig

# You can limit it to your work folder
[includeIf "gitdir:~/private_work/"]
	path = ~/.dotfiles/dotfilesconfidential/.gitconfig-user
```

The same for bash scripts. In this example we are tieing inside the [.zshrc](.zshrc):
```bash
if [[ -s "$HOME/.dotfiles/dotfilesconfidential/aliases.zsh" ]]; then
  source $HOME/.dotfiles/dotfilesconfidential/aliases.zsh
fi
```

## Thanks To... :new:

I could keep the original text here that is better than mine, but it is personal. I will make it simple, so I may thanks first [driesvints/dotfiles](https://github.com/driesvints/dotfiles) again with the awesome simple config struct. I can let it without thanks my good friend [Paulo Machado](https://github.com/pviniciusfm) that pushed me to this awesome dotfiles world.

I also like to keep the references, so here we go:
* [Github does dotfiles](https://dotfiles.github.io/)
* Both [Zach Holman](https://github.com/holman/dotfiles) and [Mathias Bynens](https://github.com/mathiasbynens/dotfiles) were great sources of inspiration.
* [Sourabh Bajaj](https://twitter.com/sb2nov/)'s [Mac OS X Setup Guide](http://sourabhbajaj.com/mac-setup/)
* [Taylor Otwell](https://twitter.com/taylorotwell) for his awesome Zsh theme!
* [Maxime Fabre](https://twitter.com/anahkiasen) for [his excellent presentation on Homebrew](https://speakerdeck.com/anahkiasen/a-storm-homebrewin).
