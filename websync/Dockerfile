FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 3000

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# fix volume for config
VOLUME /config

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# fix start up files


# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt and install dependencies
apt-get update && \
apt-get install -y nodejs npm git sshpass && \
cp /usr/bin/nodejs /usr/bin/node && \

# git pull websync and install packages
cd /root && \
git clone https://github.com/furier/websync.git && \
cd websync && \
npm install && \
npm install -g bower && \
npm install -g gulp && \
bower install --allow-root 

# gulp bit
RUN cd /root/websync && \
gulp dist && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
