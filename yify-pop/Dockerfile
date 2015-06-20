FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 4000 8889 8890 8891 8892

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# fix start up files
mv /root/start.sh /etc/my_init.d/start.sh  && \
chmod +x /etc/my_init.d/start.sh  && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt and install dependencies
apt-get update && \
apt-get install -y supervisor nodejs npm git-core && \
cp /usr/bin/nodejs /usr/bin/node && \

# clone yify repo and install packages
cd /opt && \
git clone https://github.com/yify-pop/yify-pop && \
cd yify-pop && \
npm -g install geddy && \
npm -g install peerflix && \
npm install && \

# set supervisor file
mv /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
