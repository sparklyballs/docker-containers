FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 22 8000 62062

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# set config volume
VOLUME /config

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

#set start file
mv /root/start.sh /etc/my_init.d/start.sh && \
chmod +x /etc/my_init.d/start.sh && \

# update apt and install dependencies
echo 'deb http://repo.acestream.org/ubuntu/ trusty main' > /etc/apt/sources.list.d/acestream.list && \
cd /tmp && \
curl -O http://repo.acestream.org/keys/acestream.public.key && \
apt-key add acestream.public.key && \
apt-get update -y && \
apt-get install -y acestream-engine vlc-nox python-gevent unzip ca-certificates supervisor && \

# add tv user 
adduser --disabled-password --gecos "" tv && \

# get key file
cd /tmp/ && \
curl -LOk https://github.com/ValdikSS/aceproxy/archive/6dff4771c3.zip && \
unzip 6dff4771c3.zip -d /home/tv/ && \
mv /home/tv/aceproxy-* /home/tv/aceproxy-master && \

# set password
echo 'root:password' |chpasswd && \

# set supervisor file
mv /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
