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

# startup files
ADD apache.sh /root/apache.sh
RUN mkdir -p /etc/service/apache && \
mv /root/apache.sh /etc/service/apache/run && \
chmod +x /etc/service/apache/run && \

# update apt and install dependencies
apt-get update && \
apt-get install git-core apache2 php5 php5-mysql nodejs nodejs-legacy curl -y && \
curl https://www.npmjs.com/install.sh | sh && \
npm install -g bower && \
curl -s http://getcomposer.org/installer | php && \
mv composer.phar /usr/bin/composer && \
mkdir -p /root/tempwww && \
cd /root/tempwww && \
GIT_SSL_NO_VERIFY=true git clone https://git.athaliasoft.com/athaliasoft/Cyca.git && \
apt-get install freetype* fontconfig -y && \
apt-get install subversion php5-curl php5-imagick php5-gd -y && \
cd Cyca && \
bower --allow-root update && \
composer update && \

# Enable apache mods.
a2enmod php5 && \
a2enmod rewrite && \
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
EXPOSE 80

