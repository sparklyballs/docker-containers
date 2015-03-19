#!/bin/bash
start_mysql(){
    /usr/bin/mysqld_safe --datadir=/DATABASE > /dev/null 2>&1 &
    RET=1
    while [[ RET -ne 0 ]]; do
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
        sleep 1
    done
}

# If databases do not exist create them
if [ -f /DATABASE/mysql/user.MYD ]; then
  echo "Database exists."
else
  echo "Creating database."
  /usr/bin/mysql_install_db --datadir=/DATABASE >/dev/null 2>&1
  start_mysql
  echo "Database created. Granting access to 'root' ruser for all hosts."
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION"
  mysqladmin -u root shutdown
  chown -R nobody:users /DATABASE
  chmod -R 755 /DATABASE
fi

echo "Starting MariaDB..."
/usr/bin/mysqld_safe --skip-syslog --datadir='/DATABASE'


