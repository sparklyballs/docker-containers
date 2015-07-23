# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Add local files
ADD src/ /root/

# set volume
VOLUME /config 

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# minetest cmake options as a variable
configOPTS="-DENABLE_GETTEXT=TRUE \
-DENABLE_CURL=TRUE \
-DENABLE_REDIS=TRUE \
-DENABLE_GETTEXT=TRUE \
-DRUN_IN_PLACE=FALSE \
-DBUILD_SERVER=TRUE" && \

# set build dependencies as variables
buildDeps="build-essential \
git-core \
gettext \
cmake \
doxygen \
libirrlicht-dev \
libjpeg-dev \
libxxf86vm-dev \
libogg-dev \
libvorbis-dev \
libopenal-dev \
zlib1g-dev \
libgmp-dev \
libhiredis-dev" && \


buildDepsPerm="libbz2-dev \
libpng12-dev \
libgl1-mesa-dev \
libsqlite3-dev \
libcurl4-gnutls-dev \
libfreetype6-dev \
libjsoncpp-dev" && \


runtimeDeps="libirrlicht1.8 \
libjpeg8 \
libjpeg-turbo8 \
libxxf86vm1 \
libvorbis0a \
libvorbisenc2 \
libvorbisfile3 \
libasound2 \
libasound2-data \
libasyncns0 \
libflac8 \
libogg0 \
libopenal-data \
libopenal1 \
libpulse0 \
libsndfile1 \
libhiredis0.10 \
libjsoncpp0" && \

# update apt and install build dependencies
apt-get update -qq && \
apt-get install \
--no-install-recommends \
$buildDepsPerm \
$buildDeps -qy && \

# clone minitest git repository
cd /tmp && \
git clone --depth 1 https://github.com/minetest/minetest.git && \
cd /tmp/minetest && \

# build and configure minitest
cmake . \
$configOPTS && \
make && \
make install && \

# clean build dependencies
apt-get purge --remove \
$buildDeps -qy && \
apt-get autoremove -y && \

# install runtime dependencies
apt-get install \
--no-install-recommends \
$buildDepsPerm \
$runtimeDeps -qy && \

#clean up
cd / && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
