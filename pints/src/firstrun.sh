#!/bin/bash
mkdir -p /config
if [ -f "/var/www/Pints/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "copying RaspberryPints files"
mkdir -p /var/www/Pints
cp -pr /root/RaspberryPints-2.0.1/* /var/www/Pints/
chown -R www-data:www-data /var/www/Pints
fi
