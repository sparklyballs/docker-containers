#!/bin/bash
rm -rf /var/local/mysql/*.pid
if [ -d "/DATABASE/arrdb" ]; then
echo "Using existing databases"
chown -R nobody:users /DATABASE
/usr/bin/mysqld_safe --skip-syslog &
else
echo "new setup, copying empty databases"
cp -pr /var/lib/mysql/* /DATABASE/
chown -R nobody:users /DATABASE
sleep 10s 
/usr/bin/mysqld_safe --skip-syslog &
fi

