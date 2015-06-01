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
echo "hot_standby = on" >> /data/postgresql.conf
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
