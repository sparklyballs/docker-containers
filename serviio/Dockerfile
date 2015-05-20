# set base os
FROM phusion/baseimage:0.9.16

# Set environment variables for my_init, terminal and apache
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm " LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set java ENV
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

CMD ["/sbin/my_init"]

# add local files
ADD src/ /root/

# expose port(s)
EXPOSE 23424/tcp 8895/tcp 1900/udp

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# repositories
add-apt-repository ppa:kirillshkrogalev/ffmpeg-next && \
add-apt-repository -y ppa:webupd8team/java && \

# update apt and install dependencies
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
apt-get update && \
apt-get install supervisor wget lame libmp3lame0 ffmpeg librtmp-dev oracle-java8-installer dcraw -y && \

# fetch serviio and webui, to temporay locations.
cd /root && \
wget --directory-prefix=/tmp http://download.serviio.org/releases/serviio-1.5.2-linux.tar.gz && \
tar -xvf /tmp/serviio-1.5.2-linux.tar.gz && \
mv serviio-1.5.2 serviio && \

# fix start up files
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))


