FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Expose port
EXPOSE 3306

# Add local files
ADD src/ /root/

# Configure user nobody to match unRAID's settings
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# mv startup file and make executable
mkdir -p /etc/service/mariadb && \
mkdir -p /db && \
mv /root/mariadb.sh /etc/service/mariadb/run && \
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/service/mariadb/run && \
chmod +x /etc/my_init.d/firstrun.sh && \
    
# set inotify.sh and make runsql-script executable
mkdir -p /config && \
mkdir -p /etc/service/inotify && \
mv /root/inotify.sh /etc/service/inotify/run && \
chmod +x /etc/service/inotify/run && \
chmod +x /root/runsql-script && \

# update apt
apt-get update -q && \

# Install Dependencies
apt-get install -qy mariadb-server inotify-tools && \

# Tweak my.cnf
sed -i -e 's#\(bind-address.*=\).*#\1 0.0.0.0#g' /etc/mysql/my.cnf && \
sed -i -e 's#\(log_error.*=\).*#\1 /db/mysql_safe.log#g' /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 nobody/g' /etc/mysql/my.cnf && \
echo '[mysqld]' > /etc/mysql/conf.d/innodb_file_per_table.cnf && \
echo 'innodb_file_per_table' >> /etc/mysql/conf.d/innodb_file_per_table.cnf && \
cp /etc/mysql/my.cnf /root/my.cnf && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
