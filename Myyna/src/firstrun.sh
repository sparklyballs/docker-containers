#!/bin/bash
if [ -f "/var/www/myyna/app.js" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
chown -R www-data:www-data /var/www/myyna
else
echo "fetching myyna files"
cp -pr /root/myyna /var/www/
sleep 15
chown -R www-data:www-data /var/www/myyna
fi
