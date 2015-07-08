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

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# fix up startup files
mv /root/001-bring-up-the-server.sh /etc/my_init.d/001-bring-up-the-server.sh && \
chmod +x /etc/my_init.d/*.sh && \

# install dependencies
apt-get update -qq && \
apt-get install \
supervisor \
tftpd-hpa -qy && \

# initial folder permission
chown root:root /images && \

#clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

