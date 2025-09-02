# `audy/dotflies`

Austin G. Davis-Richardson

![~/. (fly)](./logo.png?raw=true)

## Installation

### Install Dependencies

#### ubuntu

```sh
apt-get install -y tmux htop neovim curl git zsh build-essential
```

#### macos

after cloning:

```sh
# uses ~/.config/homebrew/Brewfile
brew bundle --global
```

### Clone this repo into ~

Based on [this guide](https://queensidecastle.com/guides/tracking-your-home-directory-in-git-part-1)

Initialize repo in ~

```sh
# fetch the repo
cd ~
git init
git remote add origin git@github.com:audy/dotflies.git
git fetch

# make sure everything is ok
git reset --soft origin/main
git reset HEAD .
git diff # check modified files, ignore deleted files

# this is DANGEROUS
# only do this if the diff looks ok
git reset --hard origin/main
git checkout main

# all of the dotfiles should now be in ~
```
