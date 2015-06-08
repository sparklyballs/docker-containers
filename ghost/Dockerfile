FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Add required files that are local
ADD src/ /root/

# expose ports
EXPOSE 2368

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# fix executables
mv /root/*.sh /etc/my_init.d/ && \
chmod +x /etc/my_init.d/* && \

# update apt and install dependencies
apt-get update -qq && \
apt-get install \
wget \
nodejs \
unzip \
supervisor \
npm -y && \
cp /usr/bin/nodejs /usr/bin/node && \

# fetch ghost files with wget
mkdir -p /root/ghost && \
cd /root/ghost && \
wget -P /tmp https://ghost.org/zip/ghost-0.6.4.zip && \
unzip /tmp/ghost-0.6.4.zip && \
npm install --production && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
