# set base os
FROM phusion/baseimage:0.9.16

# set environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR="/var/log/apache2" APACHE_LOCK_DIR="/var/lock/apache2" APACHE_PID_FILE="/var/run/apache2.pid"

CMD ["/sbin/my_init"]

# add local files
ADD src/ /root/

# expose ports
EXPOSE 80/tcp 5140/udp 9200/tcp

# fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# set startup files
mkdir -p /etc/service/apache && \
mv /root/apache.sh /etc/service/apache/run && \
chmod +x /etc/service/apache/run && \
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \
mkdir -p /etc/service/elasticsearch && \
mv /root/elasticsearch.sh /etc/service/elasticsearch/run && \
chmod +x /etc/service/elasticsearch/run && \
mkdir -p /etc/service/logstash && \
mv /root/logstash.sh /etc/service/logstash/run && \
chmod +x /etc/service/logstash/run && \

# update apt and install dependencies
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository ppa:webupd8team/java -y && \
apt-get update  && \
apt-get install wget apache2 php5 oracle-java7-installer -y && \

# Enable apache mods.
a2enmod php5 && \
a2enmod rewrite && \

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini && \
mv /root/apache-config.conf /etc/apache2/sites-enabled/000-default.conf && \

# Elasticsearch installation
# Start Elasticsearch by /elasticsearch/bin/elasticsearch. This will run on port 9200.
cd /opt && \
wget --no-check-certificate https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.1.tar.gz && \
tar xf elasticsearch-1.3.1.tar.gz && \
rm elasticsearch-1.3.1.tar.gz && \
mv elasticsearch-1.3.1 elasticsearch && \

# Logstash installation
wget --no-check-certificate https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz && \
tar xf logstash-1.4.2.tar.gz && \
rm logstash-1.4.2.tar.gz && \
mv logstash-1.4.2 logstash && \
chown -R nobody:users /opt && \

# Kibana installation
mkdir /root/kibana-temp && \
cd /root/kibana-temp && \
wget --no-check-certificate https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz && \
tar xf kibana-3.1.0.tar.gz && \
rm kibana-3.1.0.tar.gz && \
mv kibana-3.1.0 kibana && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
