FROM ubuntu:latest

RUN apt-get update

RUN apt-get install -y \
  git \
  tmux \
  vim \
  zsh

ADD . /root/.dotfiles
WORKDIR /root/.dotfiles

RUN ./bootstrap.sh

WORKDIR /root

ENTRYPOINT ["/bin/zsh"]
