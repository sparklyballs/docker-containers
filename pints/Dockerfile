FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root
ENV TERM xterm
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
RUN mkdir /etc/service/mariadb && \
mkdir -p /config/databases && \
chown -R nobody:users /config && \


# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt
apt-get update -q && \

# Install dependencies etc....
apt-get install -qy wget unzip mariadb-server apache2 php5 php5-mysql && \

# Tweak my.cnf
sed -i -e 's#\(bind-address.*=\).*#\1 0.0.0.0#g' /etc/mysql/my.cnf && \
sed -i -e 's#\(log_error.*=\).*#\1 /config/databases/mysql_safe.log#g' /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 nobody/g' /etc/mysql/my.cnf && \
echo '[mysqld]' > /etc/mysql/conf.d/innodb_file_per_table.cnf && \
echo 'innodb_file_per_table' >> /etc/mysql/conf.d/innodb_file_per_table.cnf && \

# Enable apache mods.
a2enmod php5 && \
a2enmod rewrite && \

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# fetch raspberry pints
RUN cd /root && \
wget --no-check-certificate https://github.com/RaspberryPints/RaspberryPints/archive/2.0.1.zip && \
unzip 2.0.1.zip && \


# clean up lists
rm -rf /var/lib/apt/lists /usr/share/man /usr/share/doc && \

# startup files
mkdir -p /etc/service/www-apache etc/service/mariadb
ADD apache.sh /etc/service/www-apache/run
ADD mariadb.sh etc/service/mariadb/run
ADD firstrun.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/service/www-apache/run && \
chmod +x etc/service/mariadb/run && \
chmod +x /etc/my_init.d/firstrun.sh

VOLUME /config
# set ports
EXPOSE 80 3306
