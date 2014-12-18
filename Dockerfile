FROM debian:wheezy

MAINTAINER hlepesant <hugues@lepesant.com>

ENV DEBIAN_FRONTEND noninteractive

ENV SHELL /bin/bash

RUN echo "deb http://ftp.fr.debian.org/debian/ wheezy main contrib non-free" > /etc/apt/sources.list
RUN echo "deb-src http://ftp.fr.debian.org/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://ftp.fr.debian.org/debian/ wheezy-updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://ftp.fr.debian.org/debian/ wheezy-updates main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade
RUN apt-get -y install curl sudo apt-utils net-tools procps vim
RUN apt-get install -y slapd
RUN apt-get clean

RUN echo 'shell /bin/bash' > ~/.screenrc

EXPOSE 389

#VOLUME ["/srv"]
#WORKDIR /srv

#ADD entrypoint.sh /root/entrypoint.sh
#RUN chmod +x /root/entrypoint.sh

ENTRYPOINT["/usr/sbin/slapd", "-u", "openldap", "-g", "openldap", "-d3"]
