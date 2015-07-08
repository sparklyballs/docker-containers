FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# add local files
ADD src/ /root/ 

# Expose ports
EXPOSE 69/tcp 69/udp

# set volume
VOLUME /images

# fix up startup files
RUN mv /root/001-bring-up-the-server.sh /etc/my_init.d/001-bring-up-the-server.sh && \
chmod +x /etc/my_init.d/*.sh && \

# install dependencies
apt-get update -qq && \
apt-get install \
supervisor \
tftpd-hpa -qy && \

#clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

