FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 80 443

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# set config volume
VOLUME /config

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# fix startup files
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt and install dependencies
apt-get update && \
apt-get install -y wget openjdk-7-jre-headless supervisor && \

# fetch simplehelp and unpack
cd /root && \
wget --no-check-certificate --directory-prefix=/tmp http://simple-help.com/releases/SimpleHelp-linux-amd64.tar.gz && \ 
tar -xvf /tmp/SimpleHelp-linux-amd64.tar.gz && \

# set supervisor file
mv /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

