FROM ubuntu:latest

RUN apt-get update

RUN apt-get install -y \
  git \
  vim \
  zsh

ADD . /root/
WORKDIR root

ENV term=xterm
RUN ./bootstrap.sh

ENTRYPOINT ["/bin/zsh"]
