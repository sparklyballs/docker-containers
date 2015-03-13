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
# Add local files
ADD /src/ root/
# Install dependencies

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list && \
apt-get update && \
apt-get install g++ curl libssl-dev apache2-utils git-core  -y && \
cd /root && \
git clone git://github.com/ry/node.git && \
cd node && \
./configure && \
make && \
make install && \
apt-get install -y mongodb-10gen && \
apt-get install imagemagick -y && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
cd /root && \
git clone https://github.com/cubettech/myyna && \
cd myyna && \
chmod -R 777 application/config uploads && \
# fix start up files
mkdir -p /etc/service/mongo && \
mkdir -p /etc/service/myyna && \
mv /root/myyna.sh /etc/service/myyna/run && \
mv /root/mongo.sh /etc/service/mongo/run && \
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/service/myyna/run && \
chmod +x /etc/service/mongo/run && \
chmod +x /etc/my_init.d/firstrun.sh && \

# Fix apache logging
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini


VOLUME /data/db
EXPOSE 3000
