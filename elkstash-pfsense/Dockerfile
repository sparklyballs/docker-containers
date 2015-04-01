FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm

# set ports
EXPOSE 80/tcp  9200/tcp 5140/udp

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# set config volume
VOLUME /config

# Fix startup files etc
RUN cp /root/startup-files/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \
mkdir /etc/service/enginx && \
cp /root/startup-files/nginx.sh /etc/service/enginx/run && \
chmod +x /etc/service/enginx/run && \
mkdir /etc/service/logstash && \
cp /root/startup-files/logstash.sh /etc/service/logstash/run && \
chmod +x /etc/service/logstash/run && \
mkdir /etc/service/elasticsearch && \
cp /root/startup-files/elasticsearch.sh /etc/service/elasticsearch/run && \
chmod +x /etc/service/elasticsearch/run && \

# Install Oracle Java 8, accept license command is required for non interactive mode
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java8-installer wget nginx && \


# Elasticsearch installation
# Start Elasticsearch by /elasticsearch/bin/elasticsearch. This will run on port 9200.
cd /opt && \
wget --no-check-certificate https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.1.tar.gz && \
tar xf elasticsearch-1.3.1.tar.gz && \
rm elasticsearch-1.3.1.tar.gz && \
mv elasticsearch-1.3.1  elasticsearch && \


# Logstash installation
wget --no-check-certificate https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz && \
tar xf logstash-1.4.2.tar.gz && \
rm logstash-1.4.2.tar.gz && \
mv logstash-1.4.2 logstash && \

# Kibana installation
wget --no-check-certificate https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz && \
tar xf kibana-3.1.0.tar.gz && \
rm kibana-3.1.0.tar.gz && \
mv kibana-3.1.0  kibana && \

# set Nginx to run child processes as root
sed -i -e 's/www-data/root/g' /etc/nginx/nginx.conf && \

# Deploy kibana to Nginx
mv /usr/share/nginx/html /usr/share/nginx/html_orig && \
mkdir /usr/share/nginx/html && \
cp -r /opt/kibana/* /usr/share/nginx/html && \


# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
