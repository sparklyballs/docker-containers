FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Add required files that are local
ADD src/ /root/

# expose ports
EXPOSE 8080 5432

# volumes
VOLUME /data /config

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# fix executables
RUN mv /root/startup-files/* /etc/my_init.d/ && \
chmod +x /etc/my_init.d/* /root/json-parser/*.sh && \
rm -rf /root/startup-files && \

# Set the locale
locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt, install python and pip
apt-get update -qq && \
apt-get install \
python3 \
python3-setuptools \
python3-pip -y && \

# install other dependencies
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
git clone https://github.com/Murodese/pynab.git /opt/pynab && \
cd /opt/pynab && \
mv /root/install.py /opt/pynab/install.py && \
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
echo "daemon off;" >> /etc/nginx/nginx.conf && \
mv /root/001-pynab /etc/nginx/sites-available/001-pynab && \
ln -s /etc/nginx/sites-available/001-pynab /etc/nginx/sites-enabled/ && \
rm /etc/nginx/sites-enabled/default && \

# set permissions
chown -R www-data:www-data /opt/pynab && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
