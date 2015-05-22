# set base os
FROM phusion/baseimage:0.9.16

# Set environment variables for my_init, terminal and apache
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm " LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR="/var/log/apache2" APACHE_LOCK_DIR="/var/lock/apache2" APACHE_PID_FILE="/var/run/apache2.pid"

# set java ENV
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

CMD ["/sbin/my_init"]

# add local files
ADD src/ /root/

# expose port(s)
EXPOSE 23424/tcp 8895/tcp 1900/udp 8780/tcp

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# repositories
add-apt-repository ppa:kirillshkrogalev/ffmpeg-next && \
add-apt-repository -y ppa:webupd8team/java && \

# update apt and install dependencies
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
apt-get update && \
apt-get install supervisor wget lame libmp3lame0 ffmpeg librtmp-dev oracle-java8-installer dcraw unzip apache2 php5 php5-curl php5-xmlrpc -y && \

# fetch serviio to temporary location.
cd /root && \
wget --directory-prefix=/tmp http://download.serviio.org/releases/serviio-1.5.2-linux.tar.gz && \
tar -xvf /tmp/serviio-1.5.2-linux.tar.gz && \
mv serviio-1.5.2 serviio && \

# fetch webui to temporary location
cd /root && \
wget --directory-prefix=/tmp  --no-check-certificate https://github.com/SwoopX/Web-UI-for-Serviio/archive/Serviio-1.5.zip && \	
unzip /tmp/Serviio-1.5.zip && \

# fix start up files
mkdir -p /etc/service/apache && \
mv /root/apache.sh /etc/service/apache/run && \
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/service/apache/run && \
chmod +x /etc/my_init.d/firstrun.sh && \

# configure apache
a2enmod php5 && \
a2enmod rewrite && \

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini && \
mv /root/apache-config.conf /etc/apache2/sites-enabled/000-default.conf && \
mv /root/ports.conf /etc/apache2/ports.conf && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))


