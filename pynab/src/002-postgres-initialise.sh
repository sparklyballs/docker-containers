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

