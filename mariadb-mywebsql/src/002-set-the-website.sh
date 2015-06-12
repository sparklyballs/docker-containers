#!/bin/bash

if [ -f "/var/www/mywebsql/index.php" ]; then
echo "using existing website"
else
echo "fetching mywebsql files"
cd /var/www
wget http://sourceforge.net/projects/mywebsql/files/latest/download -O mywebsql.zip
unzip mywebsql.zip
rm mywebsql.zip
fi
chown -R www-data:www-data /var/www/mywebsql /var/log/apache2
