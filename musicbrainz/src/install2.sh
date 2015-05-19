#!/bin/bash
cd /root/musicbrainz-server

# install libjson
apt-get update -qq 
apt-get install libjson-xs-perl -y

# install packages
cpanm --installdeps --notest .
cpanm SARTAK/MooseX-Role-Parameterized-1.02.tar.gz

# install node dependencies
npm install
./node_modules/.bin/gulp

# install musicbrainz postgres extensions
cd postgresql-musicbrainz-unaccent
make
make install
cd ..

cd postgresql-musicbrainz-collate
make
make install
cd ..

# fix postgres permissions
echo "local   all    all    trust" >> /etc/postgresql/9.4/main/pg_hba.conf
echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf
echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf




# fix crontab entry
cat <<'EOT' > /root/cronjob
0       *       *       *       *       /root/musicbrainz-server/admin/cron/slave.sh
EOT


# fix startup file

cat <<'EOT' > /etc/my_init.d/firstrun.sh
#!/bin/bash

# sanitize brainzcode for white space


 if [ -f "/data/main/postmaster.opts" ]; then
echo "postgres folders appear to be set"
else
cp /etc/postgresql/9.4/main/postgresql.conf /data/postgresql.conf
cp /etc/postgresql/9.4/main/pg_hba.conf /data/pg_hba.conf
sed -i '/^data_directory*/ s|/var/lib/postgresql/9.4/main|/data/main|' /data/postgresql.conf
sed -i '/^hba_file*/ s|/etc/postgresql/9.4/main/pg_hba.conf|/data/pg_hba.conf|' /data/postgresql.conf
mkdir -p /data/main
chown postgres /data/*
chgrp postgres /data/*
chmod 700 /data/main
/sbin/setuser postgres /usr/lib/postgresql/9.4/bin/initdb -D /data/main
/sbin/setuser postgres /usr/lib/postgresql/9.4/bin/postgres -D /data/main -c config_file=/data/main/postgresql.conf &
sleep 10s
/sbin/setuser postgres psql --command="CREATE USER musicbrainz WITH SUPERUSER PASSWORD 'musicbrainz';" >/dev/null 2>&1
sleep 5s 
killall postgres
sleep 10s
fi

if [ -f "/config/DBDefs.pm" ]; then
echo "DBDefs is in your config folder, may need editing"
cp /config/DBDefs.pm /root/musicbrainz-server/lib/DBDefs.pm
chown -R nobody:users /config
else
cp /root/DBDefs.pm /config/DBDefs.pm
cp /config/DBDefs.pm /root/musicbrainz-server/lib/DBDefs.pm
chown -R nobody:users /config
fi

crontab /root/cronjob
exec /usr/bin/supervisord -c /root/supervisord.conf
EOT

chmod +x /etc/my_init.d/firstrun.sh

# fix supervisord.conf file 

cat <<'EOT' > /root/supervisord.conf
[supervisord]
nodaemon=true
[program:postgres]
user=postgres
command=/usr/lib/postgresql/9.4/bin/postgres -D /data/main -c config_file=/data/main/postgresql.conf
[program:redis-server]
user=root
command=redis-server
EOT

