
FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root
ENV TERM xterm




# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# ADD startup file

ADD startup/movedeb.sh /root/movedeb.sh
ADD src/5071.patch /5071.patch

# Set the locale

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8 && \

# install fpm and kodi build dependencies
mkdir -p /root/project/debout && \
apt-get update && \
apt-get install -y git openjdk-7-jre-headless build-essential gawk pmount libtool nasm yasm automake cmake gperf zip unzip bison libsdl-dev libsdl-image1.2-dev libsdl-gfx1.2-dev libsdl-mixer1.2-dev libfribidi-dev liblzo2-dev libfreetype6-dev libsqlite3-dev libogg-dev libasound2-dev python-sqlite libglew-dev libcurl3 libcurl4-gnutls-dev libxrandr-dev libxrender-dev libmad0-dev libogg-dev libvorbisenc2 libsmbclient-dev libmysqlclient-dev libpcre3-dev libdbus-1-dev libjasper-dev libfontconfig-dev libbz2-dev libboost-dev libenca-dev libxt-dev libxmu-dev libpng-dev libjpeg-dev libpulse-dev mesa-utils libcdio-dev libsamplerate-dev libmpeg3-dev libflac-dev libiso9660-dev libass-dev libssl-dev fp-compiler gdc libmpeg2-4-dev libmicrohttpd-dev libmodplug-dev libssh-dev gettext cvs python-dev libyajl-dev libboost-thread-dev libplist-dev libusb-dev libudev-dev libtinyxml-dev libcap-dev autopoint libltdl-dev swig libgtk2.0-bin libtag1-dev libtiff-dev libnfs1 libnfs-dev libxslt-dev libbluray-dev software-properties-common python-software-properties ruby-dev && \
gem install fpm && \
# get source, patch it and prepare for build

# Download XBMC, pick version from github
cd / && \
git clone https://github.com/xbmc/xbmc.git && \
cd xbmc && \
mv /5071.patch . && \
git checkout 14.1-Helix && \
git apply 5071.patch && \
# Configure, make, clean.
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
make DESTDIR=/root/project install && \

# create package
cd /root/project/debout && \
fpm -s dir -t deb -n kodi-headless -v 0.0.3 -C /root/project  \
-d "libelf1 (>= 0.158-0ubuntu5.2)" \
-d "libxau6 (>= 1:1.0.8-1)" \
-d "libxdmcp6 (>= 1:1.1.1-1)" \
-d "libxcb1 (>= 1.10-2ubuntu1)" \
-d "libx11-data (>= 2:1.6.2-1ubuntu2)" \
-d "libx11-6 (>= 2:1.6.2-1ubuntu2)" \
-d "libxext6 (>= 2:1.3.2-1)" \
-d "libxml2 (>= 2.9.1+dfsg1-3ubuntu4.4)" \
-d "sgml-base (>= 1.26+nmu4ubuntu1)" \
-d "libaacs0 (>= 0.7.0-1)" \
-d "libasound2-data (>= 1.0.27.2-3ubuntu7)" \
-d "libasound2 (>= 1.0.27.2-3ubuntu7)" \
-d "libasyncns0 (>= 0.8-4ubuntu2)" \
-d "libatk1.0-data (>= 2.10.0-2ubuntu2)" \
-d "libatk1.0-0 (>= 2.10.0-2ubuntu2)" \
-d "libavahi-common-data (>= 0.6.31-4ubuntu1)" \
-d "libavahi-common3 (>= 0.6.31-4ubuntu1)" \
-d "libavahi-client3 (>= 0.6.31-4ubuntu1)" \
-d "libavutil52 (>= 6:9.16-0ubuntu0.14.04.1)" \
-d "libgsm1 (>= 1.0.13-4)" \
-d "libmp3lame0 (>= 3.99.5+repack1-3ubuntu1)" \
-d "libopenjpeg2 (>= 1.3+dfsg-4.7ubuntu1)" \
-d "libopus0 (>= 1.1-0ubuntu1)" \
-d "liborc-0.4-0 (>= 1:0.4.18-1ubuntu1)" \
-d "libschroedinger-1.0-0 (>= 1.0.11-2ubuntu1)" \
-d "libspeex1 (>= 1.2~rc1.1-1ubuntu1)" \
-d "libogg0 (>= 1.3.1-1ubuntu1)" \
-d "libtheora0 (>= 1.1.1+dfsg.1-3.2)" \
-d "libva1 (>= 1.3.0-2)" \
-d "libvorbis0a (>= 1.3.2-1.3ubuntu1)" \
-d "libvorbisenc2 (>= 1.3.2-1.3ubuntu1)" \
-d "libvpx1 (>= 1.3.0-2)" \
-d "libx264-142 (>= 2:0.142.2389+git956c8d8-2)" \
-d "libxvidcore4 (>= 2:1.3.2-9ubuntu1)" \
-d "libavcodec54 (>= 6:9.16-0ubuntu0.14.04.1)" \
-d "libavformat54 (>= 6:9.16-0ubuntu0.14.04.1)" \
-d "libavresample1 (>= 6:9.16-0ubuntu0.14.04.1)" \
-d "libfreetype6 (>= 2.5.2-1ubuntu2.2)" \
-d "libswscale2 (>= 6:9.16-0ubuntu0.14.04.1)" \
-d "libavfilter3 (>= 6:9.16-0ubuntu0.14.04.1)" \
-d "libbluetooth3 (>= 4.101-0ubuntu13)" \
-d "libbluray1 (>= 1:0.5.0-1)" \
-d "libcaca0 (>= 0.99.beta18-1ubuntu5)" \
-d "fonts-dejavu-core (>= 2.34-1ubuntu1)" \
-d "fontconfig-config (>= 2.11.0-0ubuntu4.1)" \
-d "libfontconfig1 (>= 2.11.0-0ubuntu4.1)" \
-d "libpixman-1-0 (>= 0.30.2-2ubuntu1)" \
-d "libxcb-render0 (>= 1.10-2ubuntu1)" \
-d "libxcb-shm0 (>= 1.10-2ubuntu1)" \
-d "libxrender1 (>= 1:0.9.8-1)" \
-d "libcairo2 (>= 1.13.0~20140204-0ubuntu1.1)" \
-d "liblockdev1 (>= 1.0.3-1.5build1)" \
-d "libcec2 (>= 2.1.4-1ubuntu2)" \
-d "libcrystalhd3 (>= 1:0.0~git20110715.fdd2f19-9ubuntu1)" \
-d "libcups2 (>= 1.7.2-0ubuntu1.2)" \
-d "libdatrie1 (>= 0.2.8-1)" \
-d "libpciaccess0 (>= 0.13.2-1)" \
-d "libdrm-intel1 (>= 2.4.56-1~ubuntu1)" \
-d "libdrm-nouveau2 (>= 2.4.56-1~ubuntu1)" \
-d "libdrm-radeon1 (>= 2.4.56-1~ubuntu1)" \
-d "libenca0 (>= 1.15-2)" \
-d "libflac8 (>= 1.3.0-2ubuntu0.14.04.1)" \
-d "libsamplerate0 (>= 0.1.8-7)" \
-d "libjack-jackd2-0 (>= 1.9.9.5+20130622git7de15e7a-1ubuntu1)" \
-d "libsndfile1 (>= 1.0.25-7ubuntu2)" \
-d "libpulse0 (>= 1:4.0-0ubuntu11)" \
-d "libfluidsynth1 (>= 1.1.6-2)" \
-d "libfontenc1 (>= 1:1.1.2-1)" \
-d "libjpeg-turbo8 (>= 1.3.0-0ubuntu2)" \
-d "libjpeg8 (>= 8c-2ubuntu8)" \
-d "libjasper1 (>= 1.900.1-14ubuntu3.1)" \
-d "libjbig0 (>= 2.0-2ubuntu4.1)" \
-d "libtiff5 (>= 4.0.3-7ubuntu0.1)" \
-d "libgdk-pixbuf2.0-common (>= 2.30.7-0ubuntu1)" \
-d "libgdk-pixbuf2.0-0 (>= 2.30.7-0ubuntu1)" \
-d "libllvm3.4 (>= 1:3.4-1ubuntu3)" \
-d "libgl1-mesa-dri (>= 10.1.3-0ubuntu0.3)" \
-d "libglapi-mesa (>= 10.1.3-0ubuntu0.3)" \
-d "libx11-xcb1 (>= 2:1.6.2-1ubuntu2)" \
-d "libxcb-dri2-0 (>= 1.10-2ubuntu1)" \
-d "libxcb-dri3-0 (>= 1.10-2ubuntu1)" \
-d "libxcb-glx0 (>= 1.10-2ubuntu1)" \
-d "libxcb-present0 (>= 1.10-2ubuntu1)" \
-d "libxcb-sync1 (>= 1.10-2ubuntu1)" \
-d "libxdamage1 (>= 1:1.1.4-1ubuntu1)" \
-d "libxfixes3 (>= 1:5.0.1-1ubuntu1)" \
-d "libxshmfence1 (>= 1.1-2)" \
-d "libxxf86vm1 (>= 1:1.1.3-1)" \
-d "libgl1-mesa-glx (>= 10.1.3-0ubuntu0.3)" \
-d "libglew1.10 (>= 1.10.0-3)" \
-d "libgraphite2-3 (>= 1.2.4-1ubuntu1)" \
-d "libgtk2.0-common (>= 2.24.23-0ubuntu1.1)" \
-d "libthai-data (>= 0.1.20-3)" \
-d "libthai0 (>= 0.1.20-3)" \
-d "fontconfig (>= 2.11.0-0ubuntu4.1)" \
-d "libpango-1.0-0 (>= 1.36.3-1ubuntu1.1)" \
-d "libharfbuzz0b (>= 0.9.27-1ubuntu1)" \
-d "libpangoft2-1.0-0 (>= 1.36.3-1ubuntu1.1)" \
-d "libpangocairo-1.0-0 (>= 1.36.3-1ubuntu1.1)" \
-d "libxcomposite1 (>= 1:0.4.4-1)" \
-d "libxcursor1 (>= 1:1.1.14-1)" \
-d "libxi6 (>= 2:1.7.1.901-1ubuntu1)" \
-d "libxinerama1 (>= 2:1.1.3-1)" \
-d "libxrandr2 (>= 2:1.4.2-1)" \
-d "shared-mime-info (>= 1.2-0ubuntu3)" \
-d "libgtk2.0-0 (>= 2.24.23-0ubuntu1.1)" \
-d "x11-common (>= 1:7.7+1ubuntu8)" \
-d "libice6 (>= 2:1.0.8-2)" \
-d "liblcms1 (>= 1.19.dfsg-1.2ubuntu5)" \
-d "liblcms2-2 (>= 2.5-0ubuntu4)" \
-d "libtalloc2 (>= 2.1.0-1)" \
-d "libtdb1 (>= 1.2.12-1)" \
-d "libtevent0 (>= 0.9.19-1)" \
-d "libldb1 (>= 1:1.1.16-1)" \
-d "libllvm3.5 (>= 1:3.5~svn201651-1ubuntu1)" \
-d "liblzo2-2 (>= 2.06-1.2ubuntu1.1)" \
-d "libmad0 (>= 0.15.1b-8ubuntu1)" \
-d "libmicrohttpd10 (>= 0.9.33-1)" \
-d "libmikmod2 (>= 3.1.16-1)" \
-d "libmpeg2-4 (>= 0.5.1-5ubuntu1)" \
-d "mysql-common (>= 5.5.41-0ubuntu0.14.04.1)" \
-d "libmysqlclient18 (>= 5.5.41-0ubuntu0.14.04.1)" \
-d "libnfs1 (>= 1.3.0-2ubuntu1)" \
-d "libntdb1 (>= 1.0-2ubuntu1)" \
-d "libpcrecpp0 (>= 1:8.31-2ubuntu2)" \
-d "libplist1 (>= 1.10-1)" \
-d "libsdl1.2debian (>= 1.2.15-8ubuntu1.1)" \
-d "libvorbisfile3 (>= 1.3.2-1.3ubuntu1)" \
-d "libsdl-mixer1.2 (>= 1.2.12-10)" \
-d "libshairport1 (>= 1.2.1~git20120110.aeb4987-2ubuntu1)" \
-d "libsm6 (>= 2:1.2.1-2)" \
-d "libssh-4 (>= 0.6.1-0ubuntu3.1)" \
-d "libtag1-vanilla (>= 1.9.1-2)" \
-d "libtinyxml2.6.2 (>= 2.6.2-2)" \
-d "libva-x11-1 (>= 1.3.0-2)" \
-d "libva-glx1 (>= 1.3.0-2)" \
-d "libvdpau1 (>= 0.7-1)" \
-d "libwbclient0 (>= 2:4.1.6+dfsg-1ubuntu2.14.04.4)" \
-d "libxt6 (>= 1:1.1.4-1)" \
-d "libxmu6 (>= 2:1.1.1-1)" \
-d "libxpm4 (>= 1:3.5.10-1)" \
-d "libxaw7 (>= 2:1.0.12-1)" \
-d "libxcb-shape0 (>= 1.10-2ubuntu1)" \
-d "libxslt1.1 (>= 1.1.28-2build1)" \
-d "libxtst6 (>= 2:1.2.2-1)" \
-d "libxv1 (>= 2:1.0.10-1)" \
-d "libxxf86dga1 (>= 2:1.1.4-1)" \
-d "python2.7-minimal (>= 2.7.6-8)" \
-d "python2.7 (>= 2.7.6-8)" \
-d "python-minimal (>= 2.7.5-5ubuntu3)" \
-d "libpython-stdlib (>= 2.7.5-5ubuntu3)" \
-d "python (>= 2.7.5-5ubuntu3)" \
-d "python-talloc (>= 2.1.0-1)" \
-d "samba-libs (>= 2:4.1.6+dfsg-1ubuntu2.14.04.4)" \
-d "libass4 (>= 0.10.1-3ubuntu1)" \
-d "libglu1-mesa (>= 9.0.0-2)" \
-d "libsmbclient (>= 2:4.1.6+dfsg-1ubuntu2.14.04.4)" \
-d "libtxc-dxtn-s2tc0 (>= 0~git20131104-1.1)" \
-d "libwebp5 (>= 0.4.0-4)" \
-d "libwebpmux1 (>= 0.4.0-4)" \
-d "libyajl2 (>= 2.0.4-4)" \
-d "xml-core (>= 0.13+nmu2)" \
-d "fonts-liberation (>= 1.07.3-3)" \
-d "hicolor-icon-theme (>= 0.13-1)" \
-d "libcdio13 (>= 0.83-4.1ubuntu1)" \
-d "libgtk2.0-bin (>= 2.24.23-0ubuntu1.1)" \
-d "libmodplug1 (>= 1:0.8.8.4-4.1)" \
-d "libpostproc52 (>= 6:0.git20120821-4)" \
-d "libtag1c2a (>= 1.9.1-2)" \
-d "musescore-soundfont-gm (>= 1.3+dfsg-1)" \
-d "python-cairo (>= 1.8.8-1ubuntu5)" \
-d "python-gobject-2 (>= 2.28.6-12build1)" \
-d "python-gtk2 (>= 2.24.0-3ubuntu3)" \
-d "python-pil (>= 2.3.0-1ubuntu3)" \
-d "python-imaging (>= 2.3.0-1ubuntu3)" \
-d "python-support (>= 1.0.15)" \
-d "tcpd (>= 7.6.q-25)" \
-d "mesa-utils (>= 8.1.0-2)" \
-d "ttf-liberation (>= 1.07.3-3)" . && \




# set executable  for startup file
chmod +x /root/movedeb.sh

ENTRYPOINT ["/root/movedeb.sh"]


