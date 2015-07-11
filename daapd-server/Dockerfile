# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 3689

# Add local files
ADD src/ /root/

# set volume
VOLUME /config /music

# Set the locale
RUN locale-gen en_US.UTF-8 && \

#Adding daapd user
useradd -u 911 -U -s /bin/false daapd && usermod -G users daapd && \

# fix start up files
mv /root/init/*.sh /etc/my_init.d/ && \
rm -rf /root/init && \
chmod +x /etc/my_init.d/*.sh && \

# update apt
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \
apt-get update -qq && \

#define build-deps, runtime-deps and extra-deps
extraDeps="supervisor" && \
buildDeps="python antlr3 libasound2-dev libplist-dev libmxml-dev zlib1g-dev libunistring-dev libgcrypt20-dev make yasm autoconf automake libtool gettext libantlr3c-dev gperf git-core wget libavahi-client-dev libconfuse-dev" && \
runtimeDeps="libantlr3c-3.2-0 libasound2 libplist1 libmxml1 libunistring0 libgcrypt20 avahi-daemon libavahi-client3 libconfuse0" && \

# install extra dependencies
apt-get install --no-install-recommends \
$extraDeps -qy && \

# install build dependencies
apt-get install --no-install-recommends \
$buildDeps -qy && \

#fetch source for packages
cd /tmp && \
wget --no-check-certificate https://qa.debian.org/watch/sf.php/levent/libevent-2.1.5-beta.tar.gz && \
wget --no-check-certificate https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-x86_64-release.tar.gz && \
wget http://www.sqlite.org/sqlite-amalgamation-3.7.2.tar.gz && \
git clone https://github.com/lu-zero/libav.git libav && \
git clone https://github.com/ejurgensen/forked-daapd.git && \

# build libspotify
cd /tmp && \
tar xzf libspotify-*.tar.gz && \
cd libspotify-* && \
make install prefix=/usr/local && \

# configure and build libevent
cd /tmp && \
tar -xvf libevent-2.1.5-beta.tar.gz && \
cd libevent-2.1.5-beta && \
./configure && \
make && \
make install && \


# configure and build sqlite
cd /tmp && \
tar -xvf sqlite-amalgamation-3.7.2.tar.gz && \
cd sqlite* && \
mv /root/Makefile.in /root/Makefile.am . && \
./configure && \
make && \
make install && \

# configure and build libav
cd /tmp/libav && \
git checkout release/11 && \
./configure && \
make && \
make install && \

# configure and build forked-daapd
cd /tmp/forked-daapd && \
autoreconf -i && \
./configure \
--enable-itunes \
--enable-mpd \
--enable-spotify \
--prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var && \
make && \
make install && \
cd / && \

# clean build dependencies
apt-get purge --remove \
$buildDeps -y && \
apt-get -y autoremove && \

# install runtime dependencies
apt-get install \
$runtimeDeps -qy && \

#clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

