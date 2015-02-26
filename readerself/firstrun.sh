#!/bin/bash
if [ -f "/var/www/readerself/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching readerself files"
git clone https://github.com/readerself/readerself /var/www/readerself
chown -R www-data:www-data /var/www/readerself
fi
crontab /root/cronjob


