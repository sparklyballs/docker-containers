# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Add local files
ADD src/ /root/

# set volume
VOLUME /minetest

# expose port
EXPOSE 30000

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# fix up start files
mv /root/init/* /etc/my_init.d/ && \
rm -rf /root/init /root/service && \
chmod +x /etc/my_init.d/*.sh  && \ 

# minetest cmake options as a variable
configOPTS="-DENABLE_GETTEXT=TRUE \
-DENABLE_SOUND=FALSE \
-DENABLE_LUAJIT=TRUE \
-DENABLE_CURL=TRUE \
-DENABLE_REDIS=TRUE \
-DENABLE_GETTEXT=TRUE \
-DENABLE_SYSTEM_GMP=TRUE \
-DENABLE_LEVELDB=TRUE \
-DRUN_IN_PLACE=FALSE \
-DBUILD_SERVER=TRUE \
-DCMAKE_INSTALL_PREFIX:PATH=/opt/minetest ." && \

# set build dependencies as variables
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
libpng12-dev \
libgl1-mesa-dev \
libhiredis-dev" && \

buildDepsPerm="libbz2-dev \
libleveldb-dev \
luajit \
libluajit-5.1-dev \
libsqlite3-dev \
libcurl4-gnutls-dev \
libfreetype6-dev \
libjsoncpp-dev" && \


runtimeDeps="libhiredis0.10" && \

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

# mv games folder contents to temp location and fetch additional game from git
mkdir -p /games && \
mv /opt/minetest/share/minetest/games/* /games/ && \
git clone --depth 1 https://github.com/minetest/minetest_game.git /games/minetest && \

# clean build dependencies
apt-get purge --remove \
$buildDeps -qy && \
apt-get autoremove -y && \

# install runtime dependencies
apt-get install \
--no-install-recommends \
$buildDepsPerm \
$runtimeDeps -qy && \

# create minetest  user and mod it to suit unraid
mkdir -p /config && \
useradd -d /config --shell /bin/bash -u 99 minetest && \
groupmod -o -g 100 minetest && \

# initial permissions on /opt/minetest
chown -R minetest:minetest /opt/minetest /games /config && \

#clean up
cd / && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
