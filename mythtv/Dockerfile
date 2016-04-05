FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR="/var/log/apache2" APACHE_LOCK_DIR="/var/lock/apache2" APACHE_PID_FILE="/var/run/apache2.pid"
CMD ["/sbin/my_init"]


# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Expose ports
EXPOSE 3310 3389 5000/udp 5002/udp 5004/udp 6543 6544 6760 65001 65001/udp 

# Add local files
ADD src/ /root/

# set volumes
VOLUME /db /home/mythtv

# chfn workaround - Known issue within Dockers
RUN ln -s -f /bin/true /usr/bin/chfn && \

# Set the locale
locale-gen en_US.UTF-8 && \


# mv startup file(s) and make executable
mv /root/001-fix-the-time.sh /etc/my_init.d/001-fix-the-time.sh && \
mv /root/002-fix-the-config-etc.sh /etc/my_init.d/002-fix-the-config-etc.sh && \
mv /root/003-bring-up-the-database.sh /etc/my_init.d/003-bring-up-the-database.sh && \
mv /root/004-bring-up-rdp.sh /etc/my_init.d/004-bring-up-rdp.sh && \
mv /root/005-bring-up-the-backend.sh /etc/my_init.d/005-bring-up-the-backend.sh && \
mv /root/006-bring-up-mythweb.sh /etc/my_init.d/006-bring-up-mythweb.sh && \
chmod +x /etc/my_init.d/* && \

# add repos
echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list && \
echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list && \
echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list && \
echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list && \
apt-add-repository ppa:ubuntu-mate-dev/ppa && \
apt-add-repository ppa:ubuntu-mate-dev/trusty-mate && \
sh -c 'echo "deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu trusty main" >> /etc/apt/sources.list.d/mariadb.list' && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CBCB082A1BB943DB && \


# install mate and dependencies
apt-get update -qq && \
apt-get install -qy --force-yes --no-install-recommends \
wget \
openjdk-7-jre \
sudo \
mate-desktop-environment-core \
x11vnc \
xvfb \
gtk2-engines-murrine \
ttf-ubuntu-font-family \
supervisor && \

# install xrdp
apt-get install \
xrdp -y && \
mv /root/xrdp.ini /etc/xrdp/xrdp.ini && \

# install mythtv-backend and mariadb-server
apt-get install \
mariadb-server \
pwgen \
mythtv-backend -y && \

# install mythweb
apt-get install \
mythweb -y && \


# Configure apache
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini && \
mv /root/ports.conf /etc/apache2/ports.conf && \
mv /root/000-default-mythbuntu.conf /etc/apache2/sites-available/000-default-mythbuntu.conf && \
mv /root/mythweb.conf /etc/apache2/sites-available/mythweb.conf  && \

# mythweb CGI fix: See https://bugs.launchpad.net/mythbuntu/+bug/1316409
ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load && \
echo AddHandler cgi-script .cgi .pl >> /etc/apache2/mods-enabled/mime.conf && \

# Tweak my.cnf
mv /root/my.cnf /etc/mysql/my.cnf && \

# set mythtv to uid99 and gid100
usermod -u 99 mythtv && \
usermod -g 100 mythtv && \

# create/place required files/folders
mkdir -p /home/mythtv/.mythtv /var/lib/mythtv /var/log/mythtv /var/log/mysql /var/run/mysqld /root/.mythtv && \
touch /var/log/mysql/mysql.log && \

# set a password for user mythtv and add to required groups
echo "mythtv:mythtv" | chpasswd && \
usermod -s /bin/bash -d /home/mythtv -a -G users,mythtv,adm,sudo mythtv && \

# set permissions for files/folders
chown -R mythtv:users /db /var/lib/mythtv /var/log/mythtv /var/log/mysql /var/run/mysqld && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
