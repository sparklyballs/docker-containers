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
fonts-lmodern \
javascript-common \
libjbig0 \
libjpeg-turbo8 \
libjpeg8 \
libjs-jquery \
libjs-jquery-mousewheel \
liblcms2-2 \
libtiff5 \
libwebp5 \
libwebpmux1 \
lmodern \
python-imaging \
python-pil \
tex-common -y

# install pip packages
pip install uwsgi

# fetch photofloat from git
mkdir -p /var/www
git clone git://git.zx2c4.com/PhotoFloat /var/www/PhotoFloat
cd /var/www/PhotoFloat
rm web/js/999-googletracker.js

#  fix up configure file for server deployment
cat <<'EOT' > /var/www/PhotoFloat/deployment-config.mk
WEB_SERVER := localhost
WEB_SERVER_URL := localhost

HTDOCS_PATH := /var/www/PhotoFloat
HTDOCS_USER := nginx

FLASK_USER := photofloat
FLASK_PATH := /var/www/uwsgi/photofloat
EOT


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
