FROM phusion/baseimage:0.9.16

ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME="/root" TERM="xterm"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# expose ports
EXPOSE 5050 8080 8081 9090

# Add local files
ADD /src/ /root/

# volumes
VOLUME /downloads /config /tv-shows /movies

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# set startup files
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
mkdir -p /etc/service/couchpotato /etc/service/sickbeard /etc/service/sabnzbd && \
mv /root/couchpotato.sh /etc/service/couchpotato/run && \
mv /root/sickbeard.sh /etc/service/sickbeard/run && \
mv /root/sabnzbd.sh /etc/service/sabnzbd/run && \
chmod +x  /etc/service/couchpotato/run /etc/service/sickbeard/run /etc/service/sabnzbd/run && \
chmod +x /etc/my_init.d/*.sh && \

# add repos and update apt
add-apt-repository ppa:jcfp/ppa && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" && \
apt-get update -qq && \

# Install Dependencies
apt-get install \
python \
python-cheetah \
ca-certificates \
wget \
unrar \
par2 \
sabnzbdplus \
sabnzbdplus-theme-mobile \
curl \
git-core -y && \

# Install SickBeard
git clone https://github.com/midgetspy/Sick-Beard.git /opt/sickbeard && \

# Install CouchPotato
git clone https://github.com/RuudBurger/CouchPotatoServer.git /opt/couchpotato && \
chown -R nobody:users /opt && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))



