FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Add required files that are local
ADD src/ /root/

# expose ports
EXPOSE 80 5432

# volumes
VOLUME /data /config

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# update apt and install wget, git-core, unrar and supervisor
apt-get update -qq && \
apt-get install \
wget \
git-core \
supervisor \
unrar -y && \ 

# add postgresql repo
wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - && \
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \

# update apt again and install postgresql
apt-get update -qq && \
apt-get install \
postgresql-9.4 \
postgresql-server-dev-9.4 \
pgadmin3 -y && \

# install python and pip
apt-get install \
python3 \
python3-setuptools \
python3-pip \
libxml2-dev \
libxslt-dev \
python-dev \
libyaml-dev -y && \

# fetch pynab from git
cd /opt/ && \
git clone https://github.com/Murodese/pynab.git && \
mv /root/config.js /opt/pynab/webui/app/scripts/config.js && \

chown -R www-data:www-data pynab && \
cd pynab && \
cp config_sample.py config.py && \
pip3 install -r requirements.txt && \

# install node dependencies
apt-get install \
npm \
nodejs-legacy \
ruby \
ruby-compass -y && \

npm install -g grunt-cli bower && \

# install packages
cd webui && \
npm install && \
bower install --allow-root && \
grunt build && \

# build uswgi 
cd /tmp && \
wget http://projects.unbit.it/downloads/uwsgi-2.0.10.tar.gz && \
tar -xvf uwsgi-2.0.10.tar.gz && \
cd uwsgi-2.0.10 && \
chmod +x install.sh && \
/bin/bash install.sh pyonly  /usr/bin/uwsgi && \

# install and configure nginx
apt-get install \
nginx -y && \

# fix up start scripts and config files
mv /root/001-fix-the-time.sh /etc/my_init.d/001-fix-the-time.sh && \
mv /root/002-postgres-initialise.sh /etc/my_init.d/002-postgres-initialise.sh && \
mv /root/001-pynab /etc/nginx/sites-available/001-pynab && \
ln -s /etc/nginx/sites-available/001-pynab /etc/nginx/sites-enabled/ && \
rm /etc/nginx/sites-enabled/default && \
mkdir -p /etc/uwsgi/sites && \
mv /root/pynab.ini /etc/uwsgi/sites/pynab.ini && \

# fix executables
chmod +x /etc/my_init.d/*

