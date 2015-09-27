FROM phusion/baseimage:0.9.17
MAINTAINER sparklyballs <sparklyballs@gmail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" TERM="xterm" APTLIST="deluged \
deluge-web \
p7zip \
unrar \
unzip"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# change sources list
ADD sources.list /etc/apt/

# Update apt and install dependencies etc..
RUN add-apt-repository ppa:deluge-team/ppa && \
apt-get update -qq && \
apt-get install -qy $APTLIST && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# adding custom files
ADD services/ /etc/service/
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh && \

# fix pid and gid for nobody user
usermod -u 99 nobody && \
usermod -g 100 nobody

# set volumes and ports
VOLUME /config /downloads /incomplete-downloads
EXPOSE 8112 58846

