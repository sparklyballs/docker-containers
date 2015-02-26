# set base os
FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive
# Set correct environment variables
ENV HOME /root
RUN \
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home
CMD ["/sbin/my_init"]
# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt and install dependencies

apt-get update && \
apt-get install apache2 libapache2-mod-php5 build-essential libgd2-xpm-dev wget apache2-utils -y && \
cd /root && \
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz && \
wget http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz && \

tar xzf nagios-4.0.8.tar.gz && \
cd nagios-4.0.8 && \

# add required users and groups etc...
mkdir -p /etc/httpd/conf.d && \
useradd -m -s /bin/bash nagios && \
echo 'nagios:nagios' | chpasswd && \
usermod -G nagios nagios && \
groupadd nagcmd && \
usermod -a -G nagcmd nagios && \
usermod -a -G nagcmd www-data && \

# configure make and build

./configure \
--with-command-group=nagios && \
make all && \
make install && \
make install-init && \
make install-config && \
make install-commandmode && \
make install-webconf && \
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios && \
cd /root && \
tar xzf nagios-plugins-2.0.3.tar.gz && \
cd nagios-plugins-2.0.3 && \
./configure \
--with-nagios-user=nagios \
--with-nagios-group=nagios && \
make && \
make install && \
# clean up etc....
apt-get purge --remove build-essential wget -y && \
apt-get autoremove -y && \
ln -s /etc/init.d/nagios /etc/rc5.d/599nagios

