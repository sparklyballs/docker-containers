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

# update apt and get dependencies etc..
apt-get update && \
apt-get install -y wget acl apache2 php5-gd php-pear php5-mcrypt php5-xcache php5-xmlrpc php5 php5-sqlite unzip git rsync php5-imagick imagemagick ghostscript subversion php-mail-mimedecode tar gzip bzip2 curl php5-curl php5-dev php5-imap ssmtp php5-mysql && \

# delete default ssmtp config file
rm /etc/ssmtp/ssmtp.conf && \

# configure pear
pear config-set preferred_state alpha && \
pear install VersionControl_Git && \
pear config-set preferred_state stable && \
pear install HTTP_WebDAV_Client && \
pear install channel://pear.php.net/HTTP_OAuth-0.3.1 && \

# Enable apache mods.
a2enmod php5 && \
a2enmod rewrite && \
php5enmod mcrypt && \
php5enmod imap && \

# fetch pydio files
cd /tmp/ && \
wget http://downloads.sourceforge.net/project/ajaxplorer/pydio/stable-channel/6.0.7/pydio-core-6.0.7.zip && \
unzip pydio-core-6.0.7.zip && \
rm pydio-core-6.0.7/.htaccess && \
mv pydio-core-6.0.7 pydio && \
mv pydio /root/ && \

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
mv /root/php.ini /etc/php5/apache2/php.ini && \
chown root:root /etc/php5/apache2/php.ini && \
mv /root/apache-config.conf /etc/apache2/sites-enabled/000-default.conf && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
