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

# also download `scratch` scripts

RUN git \
  clone \
  https://github.com/audy/scratch.git .scratch && cd .scratch && ./install


ENTRYPOINT ["/bin/zsh"]
