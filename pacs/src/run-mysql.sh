#!/bin/bash
mysql_install_db
/usr/bin/mysqld_safe &
sleep 5s
# Create the 'pacsdb' and 'arrdb' databases, and 'pacs' and 'arr' DB users.
mysql -uroot < /DATABASE/arrdb/db.opt
# Load the 'pacsdb' database schema
mysql -upacs -ppacs pacsdb < /DICOM/dcm4chee/dcm4chee-2.17.1-mysql/sql/create.mysql
# Load the 'arrdb' database schema
mysql -uarr -parr arrdb < /DICOM/dcm4chee/dcm4chee-arr-3.0.11-mysql/sql/dcm4chee-arr-mysql.ddl
killall mysqld
sleep 5s
