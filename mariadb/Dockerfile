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

# Add local files
ADD src/ root/

# get dependecies

RUN apt-get update && \
apt-get install -y mariadb-server apache2 php5 php5-mysql wget unzip && \
cd /var/www && \
wget http://sourceforge.net/projects/mywebsql/files/latest/download -O mywebsql.zip && \
unzip mywebsql.zip && \
rm mywebsql.zip && \
chown -R www-data:www-data /var/www/mywebsql && \

# clean up 
apt-get purge --remove -y unzip wget && \
apt-get autoremove -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \


# Enable apache mods, for mywebsql
a2enmod php5 && \
a2enmod rewrite && \
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini && \
mv /root/apache-config.conf /etc/apache2/sites-enabled/000-default.conf && \

# Tweak my.cnf
sed -i -e 's#\(bind-address.*=\).*#\1 0.0.0.0#g' /etc/mysql/my.cnf && \
sed -i -e 's#\(log_error.*=\).*#\1 /db/mysql_safe.log#g' /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 nobody/g' /etc/mysql/my.cnf && \
echo '[mysqld]' > /etc/mysql/conf.d/innodb_file_per_table.cnf && \
echo 'innodb_file_per_table' >> /etc/mysql/conf.d/innodb_file_per_table.cnf && \

# fix up start files
mkdir -p /etc/service/mariadb && \
mkdir -p /db && \
mv /root/mariadb.sh /etc/service/mariadb/run && \
chmod +x /etc/service/mariadb/run && \
mkdir -p /etc/service/apache && \
mv /root/apache.sh /etc/service/apache/run && \
chmod +x /etc/service/apache/run

EXPOSE 80 3306
