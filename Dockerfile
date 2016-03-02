FROM ubuntu:latest

RUN apt-get update

RUN apt-get install -y \
  git \
  vim \
  zsh

ADD . /root/.dotfiles
WORKDIR /root/.dotfiles

ENV term=xterm
RUN ./bootstrap.sh

WORKDIR /root

ENTRYPOINT ["/bin/zsh"]
