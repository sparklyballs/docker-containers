FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR="/var/log/apache2" APACHE_LOCK_DIR="/var/lock/apache2" APACHE_PID_FILE="/var/run/apache2.pid"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Expose port
EXPOSE 3306 80

# Add local files
ADD src/ /root/

# Volumes
VOLUME /config /db

# Configure user nobody to match unRAID's settings
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# mv startup file and make executable
mkdir -p /etc/service/mariadb && \
mv /root/mariadb.sh /etc/service/mariadb/run && \
chmod +x /etc/service/mariadb/run && \
mkdir -p /etc/service/mywebsql && \
mv /root/apache.sh /etc/service/mywebsql/run && \
mv /root/001-set-the-time.sh /etc/my_init.d/001-set-the-time.sh && \
mv /root/002-set-the-website.sh /etc/my_init.d/002-set-the-website.sh && \
mv /root/003-set-the-dbconfig.sh /etc/my_init.d/003-set-the-dbconfig.sh && \
chmod +x /etc/service/mywebsql/run && \
chmod +x /etc/my_init.d/*.sh && \
    
# update apt
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \
apt-get update -q && \

# Install mariab
apt-get install \
mariadb-server -y && \

# install everything else 
apt-get install \
--no-install-recommends \
mysqltuner \
wget \
unzip \
php5 \
apache2 \
php5-mysql -y && \

# Tweak my.cnf
sed -i -e 's#\(bind-address.*=\).*#\1 0.0.0.0#g' /etc/mysql/my.cnf && \
sed -i -e 's#\(log_error.*=\).*#\1 /db/mysql_safe.log#g' /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 nobody/g' /etc/mysql/my.cnf && \
echo '[mysqld]' > /etc/mysql/conf.d/innodb_file_per_table.cnf && \
echo 'innodb_file_per_table' >> /etc/mysql/conf.d/innodb_file_per_table.cnf && \

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini && \
mv /root/apache-config.conf /etc/apache2/sites-enabled/000-default.conf && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

