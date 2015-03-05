# set base os
FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive

# Set environment variables for my_init, terminal and apache
ENV HOME /root
ENV TERM xterm
CMD ["/sbin/my_init"]
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
COPY excludes /etc/dpkg/dpkg.cfg.d/excludes
# startup files
ADD firstrun.sh /etc/my_init.d/firstrun.sh
ADD apache.sh /root/apache.sh
RUN mkdir -p /etc/service/apache && \
mv /root/apache.sh /etc/service/apache/run && \
chmod +x /etc/service/apache/run && \
chmod +x /etc/my_init.d/firstrun.sh && \

# update apt and install dependencies
apt-get update && \
apt-get install  git-core wget apache2 php5 php5-mysql nodejs npm curl subversion php5-curl php5-imagick php5-gd freetype* fontconfig build-essential g++ flex bison gperf ruby perl libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev libpng-dev libjpeg-dev unzip -y qtquick1-5-dev qtmultimedia5-dev ruby-qt4-test python && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true )) && \
cp /usr/bin/nodejs /usr/bin/node && \
npm install -g bower && \
curl -s http://getcomposer.org/installer | php && \
mv composer.phar /usr/bin/composer && \
mkdir -p /root/tempwww && \
cd /root/tempwww && \
GIT_SSL_NO_VERIFY=true git clone https://git.athaliasoft.com/athaliasoft/Cyca.git && \
cd Cyca && \
bower --allow-root update && \
composer update && \
cd bin && \
wget --no-check-certificate https://www.dropbox.com/s/15bjfacx5i5gewm/phantomjs && \
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
EXPOSE 80
