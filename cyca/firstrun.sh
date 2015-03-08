#!/bin/bash
if [ -f "/var/www/Cyca/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
cd /var/www/Cyca
GIT_SSL_NO_VERIFY=true git pull
chown -R www-data:www-data /var/www/Cyca
else
echo "fetching cyca files"
cp -pr /root/tempwww/Cyca /var/www/
sleep 8
chown -R www-data:www-data /var/www/Cyca
fi

