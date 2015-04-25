FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 6080 3389

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# set config volume
VOLUME /config

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Configure user nobody to match unRAID's settings
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -m -d /nobody nobody && \
usermod -s /bin/bash nobody && \
usermod -a -G adm,sudo nobody && \
echo "nobody:PASSWD" | chpasswd && \

# update apt and install dependencies
cp /etc/apt/sources.list /root/sources.list && \
echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty  main universe restricted' >> /root/sources.list && \
echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main universe restricted' >> /root/sources.list && \
echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt utopic main universe restricted' >> /etc/apt/sources.list && \
echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt utopic-updates main universe restricted' >> /etc/apt/sources.list && \
apt-get update -qq && \
apt-get install -qy --no-install-recommends x11vnc && \
mv /root/sources.list /etc/apt/sources.list && \
apt-get clean && \
apt-get update -qq && \
apt-get install -qy --force-yes --no-install-recommends xvfb openjdk-7-jre wget openbox unzip python2.7 && \
apt-get install -qy --force-yes xrdp xdg-utils && \
ln -s /usr/bin/python2.7 /usr/bin/python && \

# user folders etc.....
mkdir /nobody && \
mkdir -p /nobody/.config/openbox && \
mkdir /nobody/.cache && \
mkdir /root/.vnc && \

# install calibre
wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c "import sys; main=lambda x,y:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main('/nobody/calibre-bin', True)" && \

# move startup files and config for xrdp
mv /root/xrdp.ini /etc/xrdp/xrdp.ini && \
mkdir -p /etc/service/Xvfb && \
mv /root/Xvfb /etc/service/Xvfb/run && \
mkdir -p /etc/service/x11vnc && \
mv /root/x11vnc /etc/service/x11vnc/run && \
mkdir -p /etc/service/noVNC && \
mv /root/noVNC.sh /etc/service/noVNC/run && \
mkdir -p /etc/service/xrdp && \
mv /root/xrdp /etc/service/xrdp/run && \
mkdir -p /etc/service/xrdp-sesman && \
mv /root/xrdp-sesman /etc/service/xrdp-sesman/run && \
chmod -R +x /etc/service/ /etc/my_init.d/ && \
mv /root/autostart /nobody/.config/openbox/autostart && \
mv /root/rc.xml /nobody/.config/openbox && \

# install noVNC
mv /root/noVNC /noVNC && \

# set permissions for home folder 
chown -R nobody:users /nobody && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))


 
