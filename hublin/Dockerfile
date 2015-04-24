FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 8080 27017

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# fix up start files 
mv /root/start.sh /etc/my_init.d/start.sh && \
chmod +x /etc/my_init.d/start.sh && \
 
# update apt and install dependencies
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
apt-get update && \
apt-get install git-core nodejs npm supervisor redis-server mongodb-org mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools -y && \
cp /usr/bin/nodejs /usr/bin/node && \

# fetch hublin and install packages
cd /opt && \
git clone https://ci.open-paas.org/stash/scm/meet/meetings.git && \
cd meetings && \
cp config/db.json.sample config/db.json && \
mv /root/default.json config/default.json && \
npm install -g mocha grunt-cli bower karma-cli && \
bower install --allow-root && \
npm install && \
# set supervisor file
mv /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
