# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm

# set ports
EXPOSE 3689

# Add local files
ADD src/ /root/

# set volume
VOLUME /config /music

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \ 

# fix start up files
mv /root/001-bring-up-the-app.sh /etc/my_init.d/001-bring-up-the-app.sh && \
chmod +x /etc/my_init.d/001-bring-up-the-app.sh && \

# install dependencies
apt-get update -qq && \
apt-get install \
forked-daapd \
supervisor \
libevent-2.0-5 \
libavresample1 -qy && \
mv /root/forked-daapd_21.0-1_amd64.deb /tmp/forked-daapd_21.0-1_amd64.deb && \
dpkg -i /tmp/forked-daapd_21.0-1_amd64.deb && \
echo " deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
echo "deb-src http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
apt-get update -qq && \
apt-get install \
minidlna -qy && \

# Disable dbus for avahi
sed -i "s|#enable-dbus.*|enable-dbus=no|g" /etc/avahi/avahi-daemon.conf && \

#clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

