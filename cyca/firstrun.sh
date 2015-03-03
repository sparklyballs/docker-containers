#!/bin/bash
if [ -f "/var/www/Cyca/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching cyca files"
cp -pr cd /root/tempwww/Cyca /var/www/
chown -R www-data:www-data /var/www/Cyca
fi
