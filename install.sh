#!/bin/sh
# this script will download and install my dotfiles
# (works on ubuntu/mac os x)

set -e

git clone https://github.com/audy/dotflies.git ~/.dotflies

cd ~/.dotflies && ./link-files

mkdir -p ~/.history

# install vim plugins
nvim -E -c 'PlugInstall' -c 'qa!' || true
