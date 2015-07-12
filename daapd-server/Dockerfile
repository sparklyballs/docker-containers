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

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# fix start up files
rm -rf /etc/my_init.d && \
mv /root/my_init.d  /etc/ && \
chmod +x /etc/my_init.d/*.sh && \

# update apt
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \
apt-get update -qq && \

# set variable containing build dependencies
buildDeps="automake \
gperf \
gettext \
libtool \
yasm \
autoconf \
libgcrypt20-dev \
cmake \
build-essential \
libflac-dev \
antlr3 \
libasound2-dev \
libplist-dev \
libmxml-dev \
zlib1g-dev \
libunistring-dev \
libantlr3c-dev \
git-core \
wget \
libavahi-client-dev \
libconfuse-dev" && \

# set variable containing runtime dependencies
runtimeDeps="libgcrypt20 \
libavahi-client3 \
libflac8 \
libogg0 \
supervisor \
libantlr3c-3.2-0 \
libasound2 \
libplist1 \
libmxml1 \
libunistring0 \
avahi-daemon \
libconfuse0" && \

# install build dependencies
apt-get install --no-install-recommends \
$buildDeps -qy && \

#fetch source for packages
cd /tmp && \
wget http://curl.haxx.se/download/curl-7.43.0.tar.gz && \
wget http://taglib.github.io/releases/taglib-1.9.1.tar.gz && \
wget --no-check-certificate https://qa.debian.org/watch/sf.php/levent/libevent-2.1.5-beta.tar.gz && \
wget --no-check-certificate https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-x86_64-release.tar.gz && \
wget http://www.sqlite.org/sqlite-amalgamation-3.7.2.tar.gz && \
git clone https://github.com/FFmpeg/FFmpeg.git && \
git clone https://github.com/ejurgensen/forked-daapd.git && \

# build curl with ssl support for lastfm
cd /tmp && \
tar xvf curl-* && \
cd curl-* && \
./configure \
--prefix=/usr \
--with-ssl \
--with-zlib && \
make && \
make install && \

# build taglib
cd /tmp && \
tar xvf taglib-* && \
cd taglib-* && \
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_RELEASE_TYPE=Release . && \
make && \
make install && \
ldconfig && \

# build libspotify
cd /tmp && \
tar xzf libspotify-* && \
cd libspotify-* && \
make install prefix=/usr/local && \

# configure and build libevent
cd /tmp && \
tar xvf libevent-* && \
cd libevent-*  && \
./configure && \
make && \
make install && \


# configure and build sqlite
cd /tmp && \
tar xvf sqlite-* && \
cd sqlite-* && \
mv /root/Makefile.in /root/Makefile.am . && \
./configure && \
make && \
make install && \
 

# configure and build ffmpeg
cd /tmp/FFmpeg && \
git checkout release/2.7 && \
./configure \
--prefix=/usr \
--enable-nonfree \
--disable-static \
--enable-shared \
--disable-debug && \

make && \
make install && \

# configure and build forked-daapd
cd /tmp/forked-daapd && \
autoreconf -i && \
./configure \
--enable-itunes \
--enable-mpd \
--enable-spotify \
--enable-lastfm \
--enable-flac \
--enable-musepack \
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

