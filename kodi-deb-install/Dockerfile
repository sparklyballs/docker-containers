
FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>
ENV DEBIAN_FRONTEND noninteractive
# Set correct environment variables
ENV HOME /root
ENV TERM xterm


# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add files from local
ADD src/ root/

# Set the locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8 && \

# Configure user nobody to match unRAID's settings
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# update apt, install gdebi, wget and fetch .deb file
apt-get update && \
apt-get install -y gdebi-core wget && \
wget -O /root/kodi-headless_0.0.2_amd64.deb  "https://www.dropbox.com/s/6ro81v0dh3x0ehh/kodi-headless_0.0.2_amd64.deb?dl=0" && \
# install package and clean up
cd /root && \
gdebi -n kodi-headless_0.0.2_amd64.deb && \
apt-get purge --remove -y gdebi-core wget && \
apt-get autoremove -y && \
rm -rf /var/lib/apt/lists /usr/share/man /usr/share/doc && \
rm -rf /root/*.deb && \

# fix up startup files, make executable etc...

mkdir /etc/service/kodi && \
mv /root/kodi.sh /etc/service/kodi/run && \
chmod +x /etc/service/kodi/run && \
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \

# fix up permissions
chown -R nobody:users /opt/kodi-server

# set ports
EXPOSE 9777/udp 8080/tcp
