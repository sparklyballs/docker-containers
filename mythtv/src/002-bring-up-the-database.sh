#!/bin/bash

start_mysql(){
    /usr/bin/mysqld_safe --datadir=/db > /dev/null 2>&1 &
    RET=1
    while [[ RET -ne 0 ]]; do
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
        sleep 1
    done
}

# If databases do not exist create them
if [ -f /db/mysql/user.MYD ]; then
  echo "Database exists."
else
  echo "Creating database."
  /usr/bin/mysql_install_db --datadir=/db >/dev/null 2>&1
  start_mysql
  echo "Database created. Granting access to 'root' ruser for all hosts."
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION"
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS mythconverg"
  mysql -uroot -e "CREATE USER 'mythtv' IDENTIFIED BY 'mythtv'"
  mysql -uroot -e "GRANT ALL ON mythconverg.* TO 'mythtv' IDENTIFIED BY 'mythtv'"
  mysql -uroot -e "GRANT CREATE TEMPORARY TABLES ON mythconverg.* TO 'mythtv' IDENTIFIED BY 'mythtv'"
  mysql -uroot -e "ALTER DATABASE mythconverg DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"
  mysqladmin -u root shutdown
echo "Starting MariaDB..."
/usr/bin/supervisord -c /root/supervisor-files/db-supervisord.conf &
# test database is running before issuing timzone command
echo "Testing whether database is ready"
until [ "$( mysqladmin -u root status 2>&1 >/dev/null | grep -ci error:)" = "0" ]
do
echo "waiting....."
sleep 2s
done
exec mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql
fi

echo "Starting MariaDB..."
/usr/bin/supervisord -c /root/supervisor-files/db-supervisord.conf &
