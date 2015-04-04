FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm

# set ports
EXPOSE 6060

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# fix up start file
mv /root/startup-files/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \

# update apt and install dependencies 
apt-get update && \
apt-get install -y wget openjdk-7-jre-headless && \
mkdir -p /root/temp && \
cd /root/temp && \
wget http://www.synametrics.com/files/SynaMan/SynaManJava.tar.gz && \
gunzip -c SynaManJava.tar.gz | tar -xvf - && \
rm SynaManJava.tar.gz && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
