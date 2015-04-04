
# set base os
FROM phusion/baseimage:0.9.16

# Set environment variables for my_init, terminal and apache
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR="/var/log/apache2" APACHE_LOCK_DIR="/var/lock/apache2" APACHE_PID_FILE="/var/run/apache2.pid"
CMD ["/sbin/my_init"]

# add local files
ADD src/ /root/

# expose port(s)
EXPOSE 80

# startup files
RUN mkdir -p /etc/service/apache && \
mv /root/apache.sh /etc/service/apache/run && \
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/service/apache/run && \
chmod +x /etc/my_init.d/firstrun.sh && \

# fix nobody user to match unraid
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# install apache and piwigo dependencies
apt-get update && \
apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl wget curl lynx-cur curl unzip php5-imagick php5-xmlrpc php5-xsl php5-cgi php-auth php-auth-sasl php-net-smtp && \
 
# Enable apache mods.
a2enmod php5 && \
a2enmod rewrite && \
 
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini && \
mv /root/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

