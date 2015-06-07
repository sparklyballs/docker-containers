FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR="/var/log/apache2" APACHE_LOCK_DIR="/var/lock/apache2" APACHE_PID_FILE="/var/run/apache2.pid"

# Add required files that are local
ADD src/ /root/

# expose ports
EXPOSE 80

# volumes
VOLUME /var/www/dokuwiki

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# fix install scripts executable
RUN chmod +x /root/install.sh && \
sleep 1s && \

# installer script
/root/install.sh && \

# fix executables
chmod +x -R /etc/service && \
chmod +x /etc/my_init.d/* && \

# remove install script for cleaner final image
rm /root/install.sh

