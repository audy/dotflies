FROM ubuntu

RUN apt-get update

RUN apt-get install -y \
  git \
  htop \
  vim

ADD . /root/
WORKDIR root

RUN ./bootstrap.sh
