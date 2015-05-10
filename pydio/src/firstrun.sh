#!/bin/bash
mkdir -p /var/www/pydio
mkdir -p /config

if [ -f "/var/www/pydio/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
cd /var/www
cp -r /root/pydio/* /var/www/pydio/
chown -R www-data:www-data /var/www/pydio/data
fi

if [ -f "/config/ssmtp.conf" ]; then
rm /etc/ssmtp/ssmtp.conf
cp /config/ssmtp.conf /etc/ssmtp/ssmtp.conf
else
cp /root/ssmtp.conf /config/ssmtp.conf
chown -R nobody:users /config
echo "EDIT SSMTP CONFIG AND RESTART CONTAINER"
fi

