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

# update apt and install stuff
RUN apt-get update && \
apt-get install -y apache2 php5 php5-mysql php5-curl php5-gd screen zip php5-mcrypt wget unzip && \
cd /root && \
wget http://downloads.sourceforge.net/project/brightgamepanel/DEVEL/bgp_r0-devel-beta8.zip && \
unzip bgp_r0-devel-beta8.zip && \
mv /root/bgp_r0-devel-beta8/upload_me /root/bgp_r0-devel-beta8/bgpanel && \
rm bgp_r0-devel-beta8.zip && \

# Enable apache mods.
a2enmod php5 && \
a2enmod rewrite && \
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
ADD firstrun.sh /etc/my_init.d/firstrun.sh
ADD apache.sh /root/apache.sh
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD crontab /root/cronjob
RUN mkdir -p /etc/service/apache && \
mv /root/apache.sh /etc/service/apache/run && \
chmod +x /etc/service/apache/run && \
chmod +x /etc/my_init.d/firstrun.sh
EXPOSE 80
