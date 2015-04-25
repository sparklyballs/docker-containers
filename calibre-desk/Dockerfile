FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 9000 6080

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# fix up nobody
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -m -d /nobody nobody && \
usermod -s /bin/bash nobody && \
usermod -a -G adm,sudo nobody && \
echo "nobody:PASSWD" | chpasswd && \

# update apt and install dependencies
echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main universe restricted' > /etc/apt/sources.list && \
echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main universe restricted' >> /etc/apt/sources.list && \
apt-get update && \
apt-get install wget build-essential libxtst-dev libssl-dev libjpeg-dev -y && \
cd /tmp && \
wget http://x11vnc.sourceforge.net/dev/x11vnc-0.9.14-dev.tar.gz && \
gzip -dc x11vnc-0.9.14-dev.tar.gz | tar -xvf - && \
cd x11vnc-0.9.14/ && \
./configure && \
make && \
make install && \
apt-get purge --remove build-essential -y && \
apt-get autoremove -y && \
apt-get clean && \
apt-get install  --force-yes --no-install-recommends xvfb openjdk-7-jre openbox unzip python2.7 python -y && \
apt-get install -qy --force-yes xrdp xdg-utils && \

# fix up folders
mkdir /nobody && \
mkdir -p /nobody/.config/openbox && \
mkdir /nobody/.cache && \
mkdir /root/.vnc && \

# fetch and install calibre to /nobody
wget --no-check-certificate -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c "import sys; main=lambda x,y:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main('/nobody/', True)" && \

# fix up config files etc
mv /root/xrdp.ini /etc/xrdp/xrdp.ini && \

# fix up start files
mv /root/autostart /nobody/.config/openbox/autostart && \
mv /root/00_config.sh /etc/my_init.d/00_config.sh && \
chmod +x /etc/my_init.d/00_config.sh && \
mkdir -p /etc/service/Xvfb && \
mv /root/Xvfb /etc/service/Xvfb/run && \
chmod +x /etc/service/Xvfb/run && \
mkdir -p /etc/service/x11vnc && \
mv /root/x11vnc /etc/service/x11vnc/run && \
chmod +x /etc/service/x11vnc/run && \
mkdir -p /etc/service/xrdp && \
mv /root/xrdp /etc/service/xrdp/run && \
chmod +x /etc/service/xrdp/run && \
mkdir -p /etc/service/xrdp-sesman && \
mv /root/xrdp-sesman /etc/service/xrdp-sesman/run && \
chmod +x /etc/service/xrdp-sesman/run && \
mkdir -p /etc/service/openbox && \
mv /root/openbox /etc/service/openbox/run && \
chmod +x /etc/service/openbox/run && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
