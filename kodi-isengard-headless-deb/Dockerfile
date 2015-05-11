# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 9777/udp 8080/tcp

# Add local files
ADD src/ /root/

# Set the locale
RUN locale-gen en_US.UTF-8 && \


# Configure user nobody to match unRAID's settings
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# move startup files and set permissions
mkdir /etc/service/xbmc && \
mv /root/kodi.sh /etc/service/xbmc/run && \
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/service/xbmc/run && \
chmod +x /etc/my_init.d/firstrun.sh && \


# update apt and install gdebi-core and wget
apt-get update && \
apt-get install -y gdebi-core && \

# install kodi from .deb
mv /root/*.deb /tmp/ && \
gdebi -n /tmp/kodi-headless_15_amd64.deb && \
chown -R nobody:users /opt/kodi-server && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
