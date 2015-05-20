#!/bin/bash
cd /opt/musicbrainz

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
0       *       *       *       *       /opt/musicbrainz/admin/cron/slave.sh
EOT


# fix startup files

# fix time 
cat <<'EOT' > /etc/my_init.d/001-fix-the-time.sh
#!/bin/bash
if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
 exec  dpkg-reconfigure -f noninteractive tzdata
fi
EOT

# postgres initialisation, start postgres and redis-server

cat <<'EOT' > /etc/my_init.d/002-postgres-initialise.sh
#!/bin/bash
 if [ -f "/data/main/postmaster.opts" ]; then
echo "postgres folders appear to be set"
/usr/bin/supervisord -c /root/supervisord.conf &
sleep 10s
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
sleep 5s
/usr/bin/supervisord -c /root/supervisord.conf &
sleep 10s
/sbin/setuser postgres psql --command="CREATE USER musicbrainz WITH SUPERUSER PASSWORD 'musicbrainz';" >/dev/null 2>&1
sleep 5s
echo "BEGINNING INITIAL DATABASE IMPORT ROUTINE, THIS WILL TAKE SEVERAL HOURS, DO NOT STOP DOCKER UNTIL IT IS COMPLETED"
rm -rf /import/*
wget -nd -nH -P /import ftp://ftp.musicbrainz.org/pub/musicbrainz/data/fullexport/LATEST
LATEST=$(cat /media/dbdump/LATEST)
wget -r --no-parent -nd -nH -P /import --reject "index.html*, mbdump-edit*, mbdump-documentation*" "ftp://ftp.musicbrainz.org/pub/musicbrainz/data/fullexport/$LATEST"
pushd /import && md5sum -c MD5SUMS && popd
/opt/musicbrainz/admin/InitDb.pl --createdb --import /media/dbdump/mbdump*.tar.bz2 --echo
fi
EOT

# set DBDefs.pm file

cat <<'EOT' > /etc/my_init.d/003-configure-DBDefs.sh
#!/bin/bash
# sanitize brainzcode for white space
SANEDBRAINZCODE0=$BRAINZCODE 
SANEDBRAINZCODE1="${SANEDBRAINZCODE0#"${SANEDBRAINZCODE0%%[![:space:]]*}"}"
SANEDBRAINZCODE="${SANEDBRAINZCODE1%"${SANEDBRAINZCODE1##*[![:space:]]}"}"
if [ -f "/config/DBDefs.pm" ]; then
echo "DBDefs is in your config folder, may need editing"
sed -i "s|\(sub REPLICATION_ACCESS_TOKEN\ {\ \\\"\)[^<>]*\(\\\"\ }\)|\1${SANEDBRAINZCODE}\2|" /config/DBDefs.pm
cp /config/DBDefs.pm /opt/musicbrainz/lib/DBDefs.pm
exec chown -R nobody:users /config
else
cp /root/DBDefs.pm /config/DBDefs.pm
sed -i "s|\(sub REPLICATION_ACCESS_TOKEN\ {\ \\\"\)[^<>]*\(\\\"\ }\)|\1${SANEDBRAINZCODE}\2|" /config/DBDefs.pm
cp /config/DBDefs.pm /opt/musicbrainz/lib/DBDefs.pm
exec chown -R nobody:users /config
fi
EOT

# main import and or run musicbrainz

cat <<'EOT' > /etc/my_init.d/004-import-databases--and-or-run-everything.sh
#!/bin/bash
crontab /root/cronjob

EOT


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

