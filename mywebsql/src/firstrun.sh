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
sed -i -e "s@\$ALLOW_CUSTOM_SERVERS.*@\$ALLOW_CUSTOM_SERVERS = TRUE;@g" /var/www/mywebsql/config/servers.php
chown -R www-data:www-data /var/www/mywebsql /var/log/apache2
