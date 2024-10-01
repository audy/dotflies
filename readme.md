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
git reset --soft origin/main
git reset HEAD .
git diff # check modified files, ignore deleted files

# this is DANGEROUS
# only do this if the diff looks ok
git reset --hard origin/main
git checkout main

# all of the dotfiles should now be in ~
```

### Neovim

- [Install vim-plug](https://github.com/junegunn/vim-plug) + open nvim, run `:PlugInstall` and `:UpdateRemotePlugins`
- Neovim requires Python + some Python packages (for things like deoplete,
  black). On macOS, I use the homebrew-provided Python to install these
  dependencies:

    ```sh
    brew install python3
    pip3 install --break-system-packages ruff mypy black pynvim
    ```
