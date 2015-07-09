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
wget \
avahi-daemon \
supervisor \
build-essential \
git \
autotools-dev \
autoconf \
libtool \
gettext \
gawk \
gperf \
antlr3 \
libantlr3c-dev \
libconfuse-dev \
libunistring-dev \
libsqlite3-dev \
libavcodec-dev \
libavformat-dev \
libswscale-dev \
libavutil-dev \
libasound2-dev \
libmxml-dev \
libgcrypt11-dev \
libavahi-client-dev \
zlib1g-dev \
libavresample-dev \
libasound2-dev \
libplist-dev \
libflac-dev -qy && \

# disable dbus in avahi-daemon
sed -i "s|#enable-dbus.*|enable-dbus=no|g" /etc/avahi/avahi-daemon.conf && \

# build libevent from source 
cd /tmp && \
wget sourceforge.net/projects/levent/files/libevent/libevent-2.1/libevent-2.1.4-alpha.tar.gz && \
tar -xvf libevent-2.1.4-alpha.tar.gz && \
cd libevent-2.1.4-alpha && \
./configure && \
make && \
make install && \

# build forked-daapd from source
cd ../ && \
git clone https://github.com/ejurgensen/forked-daapd.git && \
cd forked-daapd && \
autoreconf -i && \

./configure \
--enable-itunes \
--enable-mpd \
--prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var && \

make && \
make install && \
cd / && \

# clean build dependencies
apt-get purge --remove \
build-essential \
git \
autotools-dev \
autoconf \
libtool \
gettext \
gawk \
gperf -y && \
apt-get -y autoremove && \

#clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

