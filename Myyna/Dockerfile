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
apt-get install mongodb-org apache2 php5 nodejs npm imagemagick git-core -y && \
cd /root && \
git clone https://github.com/cubettech/myyna/ && \
cd myyna && \
chmod -R 777 application/config uploads && \
# fix start up files
mkdir -p /etc/service/mongo && \
mkdir -p /etc/service/myyna && \
mv /root/myyna.sh /etc/service/myyna/run && \
mv /root/mongo.sh /etc/service/mongo/run && \
chmod +x /etc/service/myyna/run && \
chmod +x /etc/service/mongo/run


VOLUME /data/db
EXPOSE 3000
