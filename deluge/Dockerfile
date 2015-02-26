FROM phusion/baseimage:0.9.16
MAINTAINER needo <needo@superhero.org>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root
ENV TERM xterm

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# add local files
ADD sources.list /etc/apt/
ADD deluged.sh /root/deluged.sh
ADD deluge-web.sh /root/deluge-web.sh

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# Update apt and install dependencies etc..
add-apt-repository ppa:deluge-team/ppa && \
apt-get update -qq && \
apt-get install -qy deluged deluge-web unrar unzip p7zip && \


# Add deluged to runit
mkdir /etc/service/deluged && \
mv /root/deluged.sh /etc/service/deluged/run && \
chmod +x /etc/service/deluged/run && \

# Add deluge-web to runit
mkdir /etc/service/deluge-web && \
mv /root/deluge-web.sh /etc/service/deluge-web/run && \
chmod +x /etc/service/deluge-web/run

#Path to a directory that only contains the deluge.conf
VOLUME /config
VOLUME /downloads

EXPOSE 8112
EXPOSE 58846
