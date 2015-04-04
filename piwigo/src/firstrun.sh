#!/bin/bash
if [ -f "/var/www/gallery/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching piwigo files"
wget "http://piwigo.org/download/dlcounter.php?code=latest" -O /root/piwigo.zip
unzip -q /root/piwigo.zip  -d /tmp 
mv /tmp/piwigo/* /var/www/gallery 
rm -rf /tmp/piwigo /tmp/piwigo.zip
chown -R www-data:www-data /var/www/gallery
sleep 5
fi
