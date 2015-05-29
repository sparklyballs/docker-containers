#!/bin/bash

# Set the locale
locale-gen en_US.UTF-8

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody
usermod -g 100 nobody

# update apt, install python and pip
apt-get update -qq
apt-get install \
python3 \
python3-setuptools \
python3-pip -y

# install other dependencies
apt-get install \
libxml2-dev \
libxslt-dev \
libyaml-dev -y

# install wget, git-core, supervisor and unrar
apt-get install \
wget \
git-core \
supervisor \
unrar -y

# add postgresql repo
wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# update apt again and install postgresql
apt-get update -qq
apt-get install \
postgresql-9.4 \
postgresql-server-dev-9.4 \
pgadmin3 -y

# fetch pynab from git
git clone https://github.com/Murodese/pynab.git /opt/pynab
chown -R www-data:www-data /opt/pynab
cd /opt/pynab
pip3 install -r requirements.txt

# install node dependencies
apt-get install \
npm \
nodejs-legacy \
ruby \
ruby-compass -y

npm install -g grunt-cli bower

# install packages
cd webui
npm install
bower install --allow-root
grunt build

# install uswgi
pip3 install uwsgi

# install and configure nginx
apt-get install \
nginx -y
echo "daemon off;" >> /etc/nginx/nginx.conf

# fix start up and config files

cat <<'EOT' > /etc/my_init.d/001-fix-the-time.sh
#!/bin/bash
if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
 exec  dpkg-reconfigure -f noninteractive tzdata
fi
EOT

cat <<'EOT' > /etc/my_init.d/002-set-the-config.sh
#!/bin/bash
if [ -f "/config/config.py" ]; then
echo "config files exist in /config, may require editing"
cp /config/config.py /opt/pynab/
cp /config/config.js /opt/pynab/webui/app/scripts/config.js
else
cp /root/config-files/config.py /config/config.py
cp /root/config-files/config.js /config/config.js
fi
sed -i "/# host: your usenet server host ('news.supernews.com' or the like)/{n;s/.*/    'host': '${news_server}',/}" /config/config.py
sed -i "/# user: whatever your login name is/{n;s/.*/    'user': '${news_user}',/}" /config/config.py
sed -i "/# password: your password/{n;s/.*/    'password': '${news_passwd}',/}" /config/config.py
sed -i "/# make sure there aren't any quotes around it/{n;s/.*/    'port':${news_port},/}" /config/config.py
if [ -z "$news_ssl" ]; then
sed -i "/# ssl: True if you want to use SSL, False if not/{n;s/.*/    'ssl': False," /config/config.py
else
sed -i "/# ssl: True if you want to use SSL, False if not/{n;s/.*/    'ssl': True," /config/config.py
fi
cp /config/config.py /opt/pynab/config.py
cp /config/config.js /opt/pynab/webui/app/scripts/config.js
chown nobody:users /config/config.py /config/config.js 
chown -R www-data:www-data /opt/pynab
EOT

cat <<'EOT' > /etc/my_init.d/003-postgres-initialise.sh
#!/bin/bash
 if [ -f "/data/main/postmaster.opts" ]; then
echo "postgres folders appear to be set"
/usr/bin/supervisord -c /root/supervisor-files/postgres-supervisord.conf &
sleep 5s
else
cp /etc/postgresql/9.4/main/postgresql.conf /data/postgresql.conf
cp /etc/postgresql/9.4/main/pg_hba.conf /data/pg_hba.conf
sed -i '/^data_directory*/ s|/var/lib/postgresql/9.4/main|/data/main|' /data/postgresql.conf
sed -i '/^hba_file*/ s|/etc/postgresql/9.4/main/pg_hba.conf|/data/pg_hba.conf|' /data/postgresql.conf
mkdir -p /data/main
chown postgres:postgres /data/*
chmod 700 /data/main
echo "initialising empty databases in /data"
/sbin/setuser postgres /usr/lib/postgresql/9.4/bin/initdb -D /data/main >/dev/null 2>&1
echo "completed initialisation"
sleep 5s
/usr/bin/supervisord -c /root/supervisor-files/postgres-supervisord.conf &
sleep 5s
echo "setting up pynab user and database"
/sbin/setuser postgres psql --command="CREATE USER pynab WITH SUPERUSER PASSWORD 'pynab';" >/dev/null 2>&1
/sbin/setuser postgres psql --command="CREATE DATABASE pynab WITH OWNER pynab TEMPLATE template0 ENCODING 'UTF8';" >/dev/null 2>&1
/sbin/setuser postgres psql --command="GRANT ALL PRIVILEGES ON DATABASE pynab TO pynab;" >/dev/null 2>&1
sleep 5s
echo "pynab user and database created"
fi
EOT

cat <<'EOT' > /etc/my_init.d/004-start-all-the-rest-up.sh
#!/bin/bash
/usr/bin/supervisord -c /root/supervisor-files/nginx-supervisord.conf &
EOT

# fix start up files executable
chmod +x /etc/my_init.d/*

# nginx and uswgi config files

cat <<'EOT' > /etc/nginx/sites-available/001-pynab
upstream _pynab {
    server unix:/var/run/uwsgi.sock;
}

server {
    listen 8080;
    server_name api;

    log_format proxied_combined '$http_x_forwarded_for - $remote_user [$time_local]  '
                                '"$request" $status $body_bytes_sent '
                                '"$http_referer" "$http_user_agent"';

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

cat <<'EOT' > /root/pynab.ini
[uwsgi]
chmod-socket = 666
socket = /var/run/uwsgi.sock
master = true
chdir = /opt/pynab
wsgi-file = api.py
uid = root
gid = root
processes = 2
threads = 2
EOT

# supervisor config files

mkdir -p /root/supervisor-files

cat <<'EOT' > /root/supervisor-files/nginx-supervisord.conf
[supervisord]
nodaemon=true
[program:uwsgi-api]
command = /usr/local/bin/uwsgi --ini /root/pynab.ini

[program:nginx-api]
command = /usr/sbin/nginx
EOT

cat <<'EOT' > /root/supervisor-files/postgres-supervisord.conf
[supervisord]
nodaemon=true
[program:postgres]
user=postgres
command=/usr/lib/postgresql/9.4/bin/postgres -D /data/main -c config_file=/data/main/postgresql.conf
EOT

cat <<'EOT' > /root/supervisor-files/pynab-supervisord.conf
[supervisord]
nodaemon=true

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

# config.js file for pynab
mkdir -p /root/config-files

cat <<'EOT' > /root/config-files/config.js
angular.module('pynabWebuiApp').constant('PYNAB_CONFIG', {
	// example: 'http://someindexer.org:8080/'
	// don't forget the trailing slash
	// if your install is in a subdirectory, include that
	hostUrl: 'http://localhost:8080/'
});
EOT
