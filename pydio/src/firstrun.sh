#!/bin/bash
mkdir -p /var/www/pydio
if [ -f "/var/www/pydio/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
cd /var/www
cp -r /root/pydio/* /var/www/pydio/
chown -R www-data:www-data /var/www/pydio/data
fi


