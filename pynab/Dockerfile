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

# update apt, install python and pip
apt-get update -qq && \
apt-get install \
python3 \
python3-setuptools \
python3-pip -y && \

# install other dependencies
apt-get install \
libxml2-dev \
libxslt-dev \
libyaml-dev -y && \

# install wget, git-core, supervisor and unrar
apt-get install \
wget \
git-core \
supervisor \
unrar -y && \ 

# add postgresql repo
wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - && \
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \

# update apt again and install postgresql
apt-get update -qq && \
apt-get install \
postgresql-9.4 \
postgresql-server-dev-9.4 \
pgadmin3 -y && \

# fetch pynab from git
cd /opt/ && \
git clone https://github.com/Murodese/pynab.git && \

cd pynab && \
cp /root/config-files/config.py . && \
chown -R www-data:www-data /opt/pynab && \
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

# install uswgi 
pip3 install uwsgi && \

# install and configure nginx
apt-get install \
nginx -y && \
mv /root/001-pynab /etc/nginx/sites-available/001-pynab && \
ln -s /etc/nginx/sites-available/001-pynab /etc/nginx/sites-enabled/ && \
rm /etc/nginx/sites-enabled/default && \
echo "daemon off;" >> /etc/nginx/nginx.conf && \

# fix up start files
mv /root/001-fix-the-time.sh /etc/my_init.d/001-fix-the-time.sh && \
mv /root/002-set-the-config.sh /etc/my_init.d/002-set-the-config.sh && \
mv /root/003-postgres-initialise.sh /etc/my_init.d/003-postgres-initialise.sh && \
chmod +x /etc/my_init.d/* && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
