#!/bin/bash

if [ -f "/var/www/serviio/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching Serviio WebUI files"
wget https://github.com/SwoopX/Web-UI-for-Serviio/archive/Serviio-1.5.zip
unzip Serviio-1.5.zip
mv Web-UI-for-Serviio-Serviio-1.5 serviio
chown -R www-data:www-data /var/www/serviio /var/log/apache2
fi


exec /usr/bin/supervisord -c /root/supervisor/supervisord.conf
