# set base os
FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive
# Set correct environment variables
ENV HOME /root
ENV TERM xterm
CMD ["/sbin/my_init"]

# add local files
ADD amule.tar.gz  /root/
ADD debout.sh /root/movedeb.sh
# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# update apt and install build dependencies

RUN apt-get update && \
apt-get install -y wget zlib1g-dev build-essential libwxgtk3.0-dev libcrypto++-dev  ibgtk2.0-dev libupnp6-dev ruby-dev && \
gem install fpm && \
# build amule
cd /root/amule && \
wget --no-check-certificate http://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.gz && \
tar -xvf boost_1_57_0.tar.gz && \
./configure --prefix=/opt/amule/amule/bin --disable-debug --enable-optimize --with-denoise-level=3  --enable-upnp --enable-geoip --enable-nls --enable-amule-gui --enable-amule-daemon --enable-amulecmd --enable-webserver --enable-alcc --enable-alc --enable-cas --enable-wxcas --enable-mmap --with-boost=/root/amule/boost_1_57_0  && \
make && \
mkdir -p /root/project/debout  /root/debout && \
make DESTDIR=/root/project install && \
cd /root/project/debout && \
fpm -s dir -t deb -n amule-sparklyballs -v 0.0.1 -C /root/project \
-d "libcrypto++9 (>= 5.6.1-6)" \
-d "libwxgtk3.0-0 (>= 3.0.0-2)" \
-d "libvpx1 (>= 1.3.0-2)" \
-d "libxpm4 (>= 1:3.5.10-1)" \
-d "libgd3 (>= 2.1.0-3)" \
-d "libupnp6 (>= 1:1.6.17-1.2)" \
-d "ttf-dejavu-core (>= 2.34-1ubuntu1)" . && \
chmod +x /root/movedeb.sh 
VOLUME /root/debout
ENTRYPOINT ["/root/movedeb.sh"]


