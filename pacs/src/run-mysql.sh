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
  /usr/bin/mysqld_safe --skip-syslog --datadir='/DATABASE' &
sleep 5s
mysql -uroot > /root/databases.sql
mysql -upacs -ppacs pacsdb < /DICOM/dcm4chee/dcm4chee-2.17.1-mysql/sql/create.mysql
mysql -uarr -parr arrdb < /DICOM/dcm4chee/dcm4chee-arr-3.0.11-mysql/sql/dcm4chee-arr-mysql.ddl
killall mysqld
sleep 5s
  chown -R nobody:users /DATABASE
  chmod -R 755 /DATABASE
fi

echo "Starting MariaDB..."
/usr/bin/mysqld_safe --skip-syslog --datadir='/DATABASE'


