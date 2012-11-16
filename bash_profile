#!/bin/bash

# Load Pythonbrew, if you are using it
[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc

# Load RVM, if you are using it
# [[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Add rvm gems and nginx to the path
export PATH=$PATH:~/.gem/ruby/1.8/bin:/opt/nginx/sbin

# Add /usr/local/bin to the path
export PATH=/usr/local/bin:$PATH

# Rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Make a cool prompt
# ???
#PS1="$(tput setaf 5)\W $(tput sgr0)$ "

# for GTK
export PATH="$PATH:$HOME/.local/bin"

# Enable LS colors
alias ls='ls -G'
