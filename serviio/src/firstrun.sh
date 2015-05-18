#!/bin/bash

mkdir -p /var/www/serviio
mkdir -p /opt/serviio
if [ -f "/var/www/serviio/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching Serviio WebUI files"
cp -pr /root/serviio-webui/*  /var/www/serviio/
chown -R www-data:www-data /var/www/serviio /var/log/apache2
fi

if [ -d "/opt/serviio/config" ]; then
echo "using existing serviio files"
else
cp -pr /root/serviio/* /opt/serviio/

cd /opt/serviio/bin
exec ./serviio.sh
