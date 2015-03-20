#!/bin/bash
if [ -f "/DATABASE/arrdb/active_part.frm" ]; then
echo "Using existing databases"
chown -R nobody:users /DATABASE
else
cp -pr /var/lib/mysql/* /DATABASE/
chown -R nobody:users /DATABASE
mysql_install_db
/usr/bin/mysqld_safe --skip-syslog
sleep 5s
# Create the 'pacsdb' and 'arrdb' databases, and 'pacs' and 'arr' DB users.
mysql -unobody < /root/databases.sql
# Load the 'pacsdb' database schema
mysql -upacs -ppacs pacsdb < /root/create.mysql
# Load the 'arrdb' database schema
mysql -uarr -parr arrdb < /root/dcm4chee-arr-mysql.ddl
sleep 240s
killall mysqld
sleep 5s
chown -R nobody:users /DATABASE
fi
