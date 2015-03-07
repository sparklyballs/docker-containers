#!/bin/bash
mkdir -p /config
if [ -f "/var/www/baikal-regular/html/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching Baikal files"
cd /var/www
wget http://baikal-server.com/get/baikal-regular-0.2.7.tgz
tar xvf baikal-regular-0.2.7.tgz
rm baikal-regular-0.2.7.tgz
cd baikal-regular/Specific
touch ENABLE_INSTALL
chown -R www-data:www-data /var/www/baikal-regular
fi

