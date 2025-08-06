# be colorful
export TERM='xterm-256color'

# skip using completions in /opt/homebrew/share/zsh/site-functions which are
# annoying because
# they're often borken and I mostly just want to tab-complete filenames anyway
fpath=(
/usr/local/share/zsh/site-functions
/usr/share/zsh/site-functions
/usr/share/zsh/5.9/functions
)

# I always need this ?
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export PATH="${PATH}:/Users/audy/.local/bin"

# emacs keybindings
bindkey -e

# input fuckery
bindkey "\e[3~" delete-char # fixes delete key

# enable CTRL-X CTRL-E (edit command in $EDITOR)
autoload edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# stop breaking stuff
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BUNDLE_FILE_GLOBAL=~/.config/homebrew/Brewfile

#
# HISTORY
#

if [[ -e `which atuin` ]]; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

## store history in daily logs
#
## history doesn't work if the directory doesn't exist yet
#if [[ ! -e "${HOME}/.history" ]]; then
#  mkdir "${HOME}/.history"
#fi
#
#
## create one file per month
#export HISTFILE="${HOME}/.history/$(date -u +%Y-%m)"
#export SAVEHIST=100000
#setopt APPEND_HISTORY
#setopt SHARE_HISTORY
#
## per-direcctory history
## ctrl-G toggles between global and local history search
#source ~/.config/zsh/per-directory-history.zsh

# fzf shell integration
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR='nvim'

# nothing to see here
[ -f ~/.secrets ] && source ~/.secrets

# aliases
[ -f ~/.aliases ] && . ~/.aliases

#
# Prompt
#

EMOJIS=(
🌨
🍉
🍕
🍪
🎨
🐌
🐔
🐛
🐝
🐞
🐦
🐴
🐶
🐹
👽
💀
💎
🔬
🔭
🔮
🙃
🚀
🤖
🥝
🦀
🦄
)

# emoji-based terminal is essential for productivity
emoji="$EMOJIS[$RANDOM%$#EMOJIS+1]"

# left prompt
get_left_prompt() {
  # show hostname if ssh'd
  if [ ! -z $SSH_CLIENT ]; then
    hostname=`hostname`
    echo -n "(${hostname}) ${emoji}  "
  elif [ ! -z $VIM ]; then
    echo -n "%c > "
  else
    echo -n "${emoji}  "
  fi
}

# right prompt: current dir
PROMPT=$(get_left_prompt)
RPROMPT="%{%F{246}%}%c%{%F{default}%}"

# tab-complete anywhere in filename
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

autoload -Uz compinit
compinit

#
# Pager
#

export PAGER=less

#

#
# Package & Environment Managers
#

# very important path-related things
export PATH="/usr/local/sbin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

if [ -e ~/.cargo/env ]; then
  source ~/.cargo/env
fi

# NPM
export PATH=$PATH:/usr/local/share/npm/bin

# go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH:/bin

export PATH=$PATH:/Users/audy/.pixi/bin

# java
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# nextflow
export JAVA_HOME="/opt/homebrew/opt/openjdk@11/"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# so that weasyprint can see glib, pango, etc...
export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
eval "$(starship init zsh)"
