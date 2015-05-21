#!/bin/bash
mkdir -p /opt/serviio
mkdir -p /var/www/serviio
mkdir -p /config/serviio

if [ -d "/opt/serviio/config" ]; then
echo "using existing serviio files"
usr/bin/supervisord -c /root/supervisord.conf &
else
cp -pr /root/serviio/* /opt/serviio/
mv /opt/serviio/library /opt/serviio/config /config/serviio/
usr/bin/supervisord -c /root/supervisord.conf &
fi

if [ -f "/var/www/serviio/index.php" ];then
echo "using existing web interface files"
else
cp -pr /root/Web-UI-for-Serviio-Serviio-1.5/*  /var/www/serviio/
chown -R www-data:www-data /var/www/serviio
fi
