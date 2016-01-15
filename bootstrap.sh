#!/bin/bash

# this script will download and install my dotfiles
# (works on ubuntu/mac os x)

set -euo pipefail

git clone https://github.com/audy/dotflies.git ~/.dotflies

cd ~/.dotflies && ./link-files

# install vim plugins
vim -E -c 'PlugInstall' -c 'qa!'
