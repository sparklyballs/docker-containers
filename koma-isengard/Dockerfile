FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 9777/udp 8080/tcp 3306/tcp

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# set config volume
VOLUME /config

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \


# set kodi checkout version as variable
kodiCheckout=15.1-Isengard && \

# fix up startup files etc...
mkdir /etc/service/kodi && \
mkdir /etc/service/mariadb && \
mkdir -p /config/databases && \
mv /root/kodi.sh /etc/service/kodi/run && \
mv /root/001-fix-the-time.sh /etc/my_init.d/001-fix-the-time.sh && \
mv /root/media-firstrun.sh /etc/my_init.d/media-firstrun.sh && \
mv /root/mariadb.sh /etc/service/mariadb/run && \
mv /root/createuser /usr/bin/createuser && \
mv /root/createdatabase /usr/bin/createdatabase && \
chown -R nobody:users /config && \
chmod +x /etc/service/kodi/run && \
chmod +x /etc/my_init.d/media-firstrun.sh && \
chmod +x /etc/my_init.d/001-fix-the-time.sh && \
chmod +x /etc/service/mariadb/run && \
chmod +x /usr/bin/createuser && \
chmod +x /usr/bin/createdatabase && \

# set build dependencies as variable
buildDeps="build-essential \
zip \
unzip \
yasm \
gawk \
cmake \
wget \
git-core \
autoconf \
libtool \
automake \
autopoint \
swig \
doxygen \
openjdk-7-jre-headless \
gperf \
libsqlite3-dev \
libpcre3-dev \
libtag1-dev \
libbluray-dev \
libjasper-dev \
libmicrohttpd-dev \
libavahi-client-dev \
libxrandr-dev \
libssh-dev \
libsmbclient-dev \
libnfs-dev \
libboost1.54-dev \
python-dev \
libmysqlclient-dev \
libgle3-dev \
libglew-dev \
libass-dev \
libmpeg2-4-dev \
libjpeg-dev \
libflac-dev \
libvorbis-dev \
libgnutls-dev \
libbz2-ocaml-dev \
libtiff5-dev \
libyajl-dev \
libssl-dev \
libxml2-dev \
libxslt-dev \
libiso9660-dev \
libtinyxml-dev \
liblzo2-dev" && \

# set runtime dependencies as variable
runtimeDeps="zip \
libpcrecpp0 \
libtag1-vanilla \
libtag1c2a \
libaacs0 \
libbluray1 \
libjasper1 \
libjpeg-turbo8 \
libjpeg8 \
libmicrohttpd10 \
libavahi-client3 \
libavahi-common-dev \
libdbus-1-dev \
libssh-4 \
libsmbclient \
libnfs1 \
libmysqlclient18 \
libgle3 \
libglew1.10 \
libass4 \
libmpeg2-4 \
libjpeg-turbo8 \
libflac8 \
libogg0 \
libvorbis0a \
libvorbisenc2 \
libvorbisfile3 \
libbz2-ocaml \
libtiff5 \
libtiffxx5 \
libyajl2 \
libxslt1.1 \
libiso9660-8 \
libtinyxml2.6.2 \
liblzo2-2 \
libxrandr2 \
unzip" && \

# update apt
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \
apt-get update -qq && \

# Install build dependencies
apt-get install \
$buildDeps -qy && \

# fetch source packages
cd /tmp/ && \
git clone https://github.com/xbmc/xbmc.git && \
wget http://curl.haxx.se/download/curl-7.43.0.tar.gz && \

# compile curl
cd /tmp && \
tar xvf curl-* && \
cd curl-* && \
./configure \
--prefix=/usr \
--with-ssl \
--with-zlib && \
make && \
make install && \

# checkout required branch, apply patch(es), configure and build kodi
cd /tmp/xbmc && \
mv /root/headless.patch . && \
git checkout $kodiCheckout && \
git apply headless.patch && \
# Configure, make, install kodi
./bootstrap && \
./configure \
--enable-nfs \
--enable-upnp \
--enable-ssh \
--enable-libbluray \
--disable-debug \
--disable-vdpau \
--disable-vaapi \
--disable-crystalhd \
--disable-vdadecoder \
--disable-vtbdecoder \
--disable-openmax \
--disable-joystick \
--disable-rsxs \
--disable-projectm \
--disable-rtmp \
--disable-airplay \
--disable-airtunes \
--disable-dvdcss \
--disable-optical-drive \
--disable-libusb \
--disable-libcec \
--disable-libmp3lame \
--disable-libcap \
--disable-udev \
--disable-libvorbisenc \
--disable-asap-codec \
--disable-afpclient \
--disable-goom \
--disable-fishbmc \
--disable-spectrum \
--disable-waveform \
--disable-avahi \
--disable-non-free \
--disable-texturepacker \
--disable-pulse \
--disable-dbus \
--disable-alsa \
--disable-hal \
--prefix=/opt/kodi-server && \
make && \
make install && \
chown -R nobody:users /opt/kodi-server && \

# clean build area of no longer required dependencies and build files
apt-get purge -y --remove \
$buildDeps && \
apt-get -y autoremove && \

# install runtime dependencies and mariadb-server
apt-get install \
mariadb-server \
$runtimeDeps -qy && \

# Tweak my.cnf
sed -i -e 's#\(bind-address.*=\).*#\1 0.0.0.0#g' /etc/mysql/my.cnf && \
sed -i -e 's#\(log_error.*=\).*#\1 /config/databases/mysql_safe.log#g' /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 nobody/g' /etc/mysql/my.cnf && \
echo '[mysqld]' > /etc/mysql/conf.d/innodb_file_per_table.cnf && \
echo 'innodb_file_per_table' >> /etc/mysql/conf.d/innodb_file_per_table.cnf && \

# install kodisend
add-apt-repository ppa:team-xbmc/ppa && \
apt-get update -qq && \
apt-get install \
kodi-eventclients-xbmc-send -qy && \

# remove un-needed repositories
add-apt-repository --remove ppa:team-xbmc/ppa && \

# clean up
cd / && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
