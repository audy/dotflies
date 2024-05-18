# `audy/dotflies`

Austin G. Davis-Richardson

![~/. (fly)](./logo.png?raw=true)

## Installation

### Install Dependencies

```sh
apt-get install -y tmux htop neovim curl git zsh build-essential
```

### Clone this repo into ~

Based on [this guide](https://queensidecastle.com/guides/tracking-your-home-directory-in-git-part-1)

Initialize repo in ~

```
# fetch the repo
cd ~
git init
git remote add origin git@github.com:audy/dotflies.git
git fetch

# make sure everything is ok
git reset --soft origin/master
git reset HEAD .
git diff # check modified files, ignore deleted files

# this is DANGEROUS
# only do this if the diff looks ok
git reset --hard origin/master
git checkout master

# all of the dotfiles should now be in ~
```

### Neovim

1. [Install vim-plug](https://github.com/junegunn/vim-plug) + open nvim, run `:PlugInstall` and `:UpdateRemotePlugins`
2. [Install pyenv](https://github.com/pyenv/pyenv)
3. Setup a pyenv for neovim: `pyenv install 3.12 && pyenv virtualenv neovim 3.12`
4. `pyenv shell neovim && pip install neovim`
