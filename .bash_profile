#!/bin/bash

source ~/.aliases

# Load Pythonbrew, if you are using it
[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc

# Load RVM, if you are using it
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Add rvm gems and nginx to the path
export PATH=$PATH:~/.gem/ruby/1.8/bin:/opt/nginx/sbin

# Add /usr/local/bin to the path
export PATH=/usr/local/bin:$PATH

# Rbenv
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

# Make a cool prompt
export PS1='\[\033[01;30m\]\w \$\[\033[00m\] '

# for GTK
export PATH="$PATH:$HOME/.local/bin"

# Enable LS colors
export LS_COLORS='exfxcxdxbxegedabagacad'

# for pyqt
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
