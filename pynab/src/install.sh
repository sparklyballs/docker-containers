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
if [ "$news_ssl" -eq 0 ]; then
sed -i "/# ssl: True if you want to use SSL, False if not/{n;s/.*/    'ssl': False,/}" /config/config.py
else
sed -i "/# ssl: True if you want to use SSL, False if not/{n;s/.*/    'ssl': True,/}" /config/config.py
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
echo "building initial nzb import"
echo "THIS WILL TAKE SOME TIME, DO NOT STOP THE DOCKER"
cd /opt/pynab
python3 install.py >/dev/null 2>&1
echo "IMPORT COMPLETED"
fi
EOT

cat <<'EOT' > /etc/my_init.d/004-start-all-the-rest-up.sh
#!/bin/bash
mkdir -p /data/pynab-logs
chmod -R 777 /data/pynab-logs
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

cat <<'EOT' > /opt/pynab/install.py
import sys
import os
import json
import time

if __name__ == '__main__':
    print('Welcome to Pynab.')
    print('-----------------')
    print()
    print('Please ensure that you have copied and renamed config_sample.py to config.py before proceeding.')
    print(
        'You need to put in your details, too. If you are migrating from Newznab, check out scripts/convert_from_newznab.py first.')
    print()
    print('This script is destructive. Ensure that the database credentials and settings are correct.')
    print('The supplied database really should be empty, but it\'ll just drop anything it wants to overwrite.')
    print()
    
    sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))

    import config
    from pynab.db import Base, engine, Session, User, Group, Category, TvShow, Movie
    import pynab.util
    from scripts import nzedb_pre_import

    db = Session()

    start = time.time()

    print('Building tables...')
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(engine)

    from alembic.config import Config
    from alembic import command

    alembic_cfg = Config("alembic.ini")
    command.stamp(alembic_cfg, "head")

    print('Installing admin user...')
    with open('db/initial/users.json', encoding='utf-8', errors='ignore') as f:
        data = json.load(f)
        try:
            engine.execute(User.__table__.insert(), data)
        except Exception as e:
            print('Problem inserting data into database: {}'.format(e))
            sys.exit(0)

    print('Copying groups into db...')
    with open('db/initial/groups.json', encoding='utf-8', errors='ignore') as f:
        data = json.load(f)
        try:
            engine.execute(Group.__table__.insert(), data)
        except Exception as e:
            print('Problem inserting data into database: {}'.format(e))
            sys.exit(0)

    print('Copying categories into db...')
    with open('db/initial/categories.json', encoding='utf-8', errors='ignore') as f:
        data = json.load(f)
        try:
            engine.execute(Category.__table__.insert(), data)
        except Exception as e:
            print('Problem inserting data into database: {}'.format(e))
            sys.exit(0)

    print('Copying TV data into db...')
    with open('db/initial/tvshows.json', encoding='utf-8', errors='ignore') as f:
        data = json.load(f)
        chunks = [data[x:x + 500] for x in range(0, len(data), 500)]
        try:
            for chunk in chunks:
                engine.execute(TvShow.__table__.insert(), chunk)
        except Exception as e:
            print('Problem inserting data into database: {}'.format(e))
            sys.exit(0)

    print('Copying movie data into db...')
    with open('db/initial/movies.json', encoding='utf-8', errors='ignore') as f:
        data = json.load(f)
        chunks = [data[x:x + 500] for x in range(0, len(data), 500)]
        try:
            for chunk in chunks:
                engine.execute(Movie.__table__.insert(), chunk)
        except Exception as e:
            print('Problem inserting data into database: {}'.format(e))
            sys.exit(0)

    print('Copying large pre data into db...')
    try:
        nzedb_pre_import.largeNzedbPre()
    except Exception as e:
        print('Problem inserting data into database: {}'.format(e))
        sys.exit(0)

    print('Copying small pre data into db...')
    try:
        nzedb_pre_import.nzedbPre()
    except Exception as e:
        print('Problem inserting data into database: {}'.format(e))
        sys.exit(0)

    if config.postprocess.get('regex_url'):
        print('Updating regex...')
        pynab.util.update_regex()
    else:
        print('Could not update regex - no update url/key in config.py.')
        print('If you don\'t have one, buy a Newznab+ license or find your own regexes.')
        print('You won\'t be able to build releases without appropriate regexes.')

    if config.postprocess.get('blacklist_url'):
        print('Updating binary blacklist...')
        pynab.util.update_blacklist()
    else:
        print(
            'Could not update blacklist. Try the URL in config.py manually - if it doesn\'t work, post an issue on Github.')

    end = time.time()

    print('Install complete in {:.2f}s'.format(end - start))
    print('Now: activate some groups, activate desired blacklists, and run pynab.py with python3.')
    EOT
