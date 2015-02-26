# set base os
FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive
# Set correct environment variables
ENV HOME /root
ENV TERM xterm
# Configure user nobody to match unRAID's settings
RUN \
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

#Install Asset-upnp 
apt-get update && \
apt-get install -y wget && \
mkdir -p /usr/bin/asset && \
chmod -R 777 /usr/bin/asset && \
cd /usr/bin/asset && \
wget http://www.dbpoweramp.com/install/AssetUPnP-Linux-x64.tar.gz && \
tar -zxvf *.gz && \
rm *.gz && \
apt-get purge --remove -y wget && \
apt-get autoremove -y && \
apt-get clean
VOLUME /root/.dBpoweramp
VOLUME /music
EXPOSE 45537/tcp 26125/tcp 1900/udp
ENTRYPOINT ["/usr/bin/asset/bin/AssetUPnP"]

