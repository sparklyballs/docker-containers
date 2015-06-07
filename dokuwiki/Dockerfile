FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR="/var/log/apache2" APACHE_LOCK_DIR="/var/lock/apache2" APACHE_PID_FILE="/var/run/apache2.pid"

# Add required files that are local
ADD src/ /root/

# expose ports
EXPOSE 80

# volumes
VOLUME /var/www/dokuwiki

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# fix executables
mkdir -p /etc/service/apache && \
mv /root/apache.sh /etc/service/apache/run && \
mv /root/001-fix-the-time.sh /etc/my_init.d/ && \
mv /root/002-copy-files.sh /etc/my_init.d/ && \ 
chmod +x -R /etc/service && \
chmod +x /etc/my_init.d/* && \

# update apt and install dependencies
apt-get update -qq && \
apt-get install \
wget \
apache2 \
php5 \
php5-gd -y && \

# configure apache mods and php
a2enmod php5 && \
a2enmod rewrite && \
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini && \
mv /root/apache-config.conf /etc/apache2/sites-enabled/000-default.conf && \

# fetch dokuwiki from source with wget
cd /root && \
mkdir dokuwiki && \
cd dokuwiki && \
wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz && \
tar xvf dokuwiki-stable.tgz --strip 1 && \
rm dokuwiki-stable.tgz && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
