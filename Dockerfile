FROM ubuntu:18.04

RUN \
  apt-get update \
  && apt-get install -y \
    git \
    tmux \
    vim \
    zsh \
    ruby \
    irssi \
    moreutils \
  && rm -rf /var/lib/apt/lists/*

RUN gem install catsay

ADD . /root/.dotfiles
WORKDIR /root/.dotfiles

RUN ./install.sh

WORKDIR /root

# also download `scratch` scripts

RUN git \
  clone \
  https://github.com/audy/scratch.git .scratch && cd .scratch && ./install

RUN echo "hello, dotflies!" | catsay --cat random

ENTRYPOINT ["/bin/zsh"]
