#!/bin/bash
cp -pr /var/lib/mysql/* /DATABASE
chown -R nobody:users /DATABASE
mysql_install_db
/usr/bin/mysqld_safe &
sleep 5s
# Create the 'pacsdb' and 'arrdb' databases, and 'pacs' and 'arr' DB users.
mysql -uroot < /root/databases.sql
# Load the 'pacsdb' database schema
mysql -upacs -ppacs pacsdb < /root/create.mysql
# Load the 'arrdb' database schema
mysql -uarr -parr arrdb < /root/dcm4chee-arr-mysql.ddl
killall mysqld
sleep 5s
chown -R nobody:users /DATABASE
