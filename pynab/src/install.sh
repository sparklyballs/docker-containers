#!/bin/bash

# Set the locale
locale-gen en_US.UTF-8

# update apt and install wget, git-core, unrar and supervisor
apt-get update -qq
apt-get install \
wget \
git-core \
supervisor \
unrar -y

# add postgresql repo
wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# update apt again and install postgresql
apt-get update -qq
apt-get install \
postgresql-9.4 \
postgresql-server-dev-9.4 \
pgadmin3 -y

# install python and pip
apt-get install \
python3 \
python3-setuptools \
python3-pip \
libxml2-dev \
libxslt-dev \
libyaml-dev -y

# fetch pynab from git
cd /opt/
git clone https://github.com/Murodese/pynab.git

# pynab config.js
rm /opt/pynab/webui/app/scripts/config.js
cat <<'EOT' > /opt/pynab/webui/app/scripts/config.js
angular.module('pynabWebuiApp').constant('PYNAB_CONFIG', {
        // example: 'http://someindexer.org:8080/'
        // don't forget the trailing slash
        // if your install is in a subdirectory, include that
        hostUrl: 'http://localhost:80/'
});
EOT

chown -R www-data:www-data pynab
cd pynab
cp config_sample.py config.py
easy_install -U distribute
pip3 install -r requirements.txt

# install node dependencies
apt-get install \
npm \
nodejs-legacy \
ruby \
ruby-compass -y

npm install -g grunt-cli bower

# install packages
cd webui
npm install
bower install --allow-root
grunt build

# install and configure nginx
pip3 install uwsgi
ln -fs /usr/local/bin/uwsgi /usr/bin/uwsgi

apt-get install \
nginx -y

# fix up start scripts and config files

# fix time

cat <<'EOT' > /etc/my_init.d/001-fix-the-time.sh
#!/bin/bash
if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
 exec  dpkg-reconfigure -f noninteractive tzdata
fi
EOT

# initialise postgresql

cat <<'EOT' > /etc/my_init.d/002-postgres-initialise.sh
cat <<'EOT' > /etc/my_init.d/003-postgres-initialise.sh
#!/bin/bash
 if [ -f "/data/main/postmaster.opts" ]; then
echo "postgres folders appear to be set"
/usr/bin/supervisord -c /root/postgres-supervisord.conf &
sleep 10s
else
cp /etc/postgresql/9.4/main/postgresql.conf /data/postgresql.conf
cp /etc/postgresql/9.4/main/pg_hba.conf /data/pg_hba.conf
sed -i '/^data_directory*/ s|/var/lib/postgresql/9.4/main|/data/main|' /data/postgresql.conf
sed -i '/^hba_file*/ s|/etc/postgresql/9.4/main/pg_hba.conf|/data/pg_hba.conf|' /data/postgresql.conf
mkdir -p /data/main
chown postgres:postgres /data/*
chmod 700 /data/main
/sbin/setuser postgres /usr/lib/postgresql/9.4/bin/initdb -D /data/main
sleep 5s
/usr/bin/supervisord -c /root/postgres-supervisord.conf &
sleep 10s
fi
EOT

# set pynab nginx config file

cat <<'EOT' > /etc/nginx/sites-available/001-pynab
upstream _pynab {
    server unix:/var/run/uwsgi/app/pynab/socket;
}

server {
    listen 80;

    location / {
        try_files $uri @uwsgi;
    }

    location @uwsgi {
        include uwsgi_params;
        uwsgi_pass _pynab;
    }
}
EOT

ln -s /etc/nginx/sites-available/001-pynab /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default


mkdir -p /etc/uwsgi/sites
cat <<'EOT' > /etc/uwsgi/sites/pynab.ini
[uwsgi]
socket = /var/run/uwsgi/app/pynab/socket
master = true
chdir = /opt/pynab
wsgi-file = api.py
uid = www-data
gid = www-data
processes = 2
threads = 2
EOT

# fix supervisor conf files


cat <<'EOT' > postgres-supervisord.conf
[supervisord]
nodaemon=true
[program:postgres]
user=postgres
command=/usr/lib/postgresql/9.4/bin/postgres -D /data/main -c config_file=/data/main/postgresql.conf
EOT


cat <<'EOT' > /root/supervisord.conf
[program:nginx]
user=root
command=/usr/sbin/nginx -c /etc/nginx/nginx.conf

[program:scan]
command=/usr/bin/python3 /opt/pynab/scan.py update
autostart=true
autorestart=true
stopsignal=QUIT
user=www-data

[program:postproc]
command=/usr/bin/python3 /opt/pynab/postprocess.py
autostart=true
autorestart=true
stopsignal=QUIT
user=www-data

[program:prebot]
command=/usr/bin/python3 /opt/pynab/prebot.py start
autostart=true
autorestart=true
stopsignal=QUIT
user=www-data

[program:stats]
command=/usr/bin/python3 /opt/pynab/scripts/stats.py
autostart=true
autorestart=true
stopsignal=QUIT
user=www-data

[program:api]
command=/usr/bin/python3 /opt/pynab/api.py
autostart=false
autorestart=true
stopsignal=QUIT
user=www-data

[program:backfill]
command=/usr/bin/python3 /opt/pynab/scan.py backfill
autostart=false
autorestart=true
stopsignal=QUIT
user=www-data

[program:pubsub]
command=/usr/bin/python3 /opt/pynab/pubsub.py start
autostart=false
autorestart=true
stopsignal=QUIT
user=www-data

[group:pynab]
programs=scan,postproc,prebot,api,stats,backfill,pubsub
EOT

