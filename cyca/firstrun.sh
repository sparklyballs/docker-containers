#!/bin/bash
if [ -f "/var/www/Cyca/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching cyca files"
cp -pr /root/tempwww/Cyca /var/www/
sleep 20
chown -R www-data:www-data /var/www/Cyca
fi
