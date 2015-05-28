#!/bin/bash

# Set the locale
locale-gen en_US.UTF-8

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody
usermod -g 100 nobody

# update apt and install dependencies
apt-get update -qq
apt-get install \
supervisor \
nginx \
python \
python-dev \
python-pip \
git-core \
openjdk-7-jre-headless \
libtiff5-dev \
libjpeg8-dev \
zlib1g-dev \
libfreetype6-dev \
liblcms2-dev \
libwebp-dev \
tcl8.6-dev \
tk8.6-dev \
wget \
cmake \
python-tk -y

# build openjpg package
wget -P /tmp http://downloads.sourceforge.net/project/openjpeg.mirror/2.0.1/openjpeg-2.0.1.tar.gz
cd /tmp
tar xzvf openjpeg-2.0.1.tar.gz
cd openjpeg-2.0.1
cmake .
make
make install
ldconfig

# install pip packages
pip install pillow uwsgi

# fetch photofloat from git
mkdir -p /var/www
git clone git://git.zx2c4.com/PhotoFloat /var/www/PhotoFloat
cd /var/www/PhotoFloat
rm web/js/999-googletracker.js
cd web
make
mkdir albums cache

# configure nginx
echo "daemon off;" >> /etc/nginx/nginx.conf

cat <<'EOT' > /etc/nginx/sites-available/photofloat
server {
listen 80;
        location / {
                index index.html;
                root /var/www/PhotoFloat;
        }

        include uwsgi_params;
        location /albums/ {
                uwsgi_pass unix:/var/run/uwsgi-apps/photofloat.socket;
        }
        location /cache/ {
                uwsgi_pass unix:/var/run/uwsgi-apps/photofloat.socket;
        }
        location /scan {
                uwsgi_pass unix:/var/run/uwsgi-apps/photofloat.socket;
        }
        location /auth {
                uwsgi_pass unix:/var/run/uwsgi-apps/photofloat.socket;
        }
        location /photos {
                uwsgi_pass unix:/var/run/uwsgi-apps/photofloat.socket;
        }

        location /internal-cache/ {
                internal;
                alias /var/www/uwsgi/photofloat/cache/;
        }
        location /internal-albums/ {
                internal;
                alias /var/www/uwsgi/photofloat/albums/;
        }
}
EOT

ln -s /etc/nginx/sites-available/photofloat /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

cat <<'EOT' > /root/photofloat.ini
[uwsgi]
chdir = /var/www/uwsgi/%n
master = true
uid = %n
gid = %n
chmod-socket = 660
chown-socket = %n:nginx
socket = /var/run/uwsgi-apps/%n.socket
logto = /var/log/uwsgi/%n.log
processes = 4
idle = 1800
die-on-idle = true
plugins = python27
module = floatapp:app
EOT
