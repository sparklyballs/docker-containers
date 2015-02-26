#!/bin/bash
if [ -f "/var/www/bgpanel/index.php" ]; then
echo "website files already loaded"
chown -R www-data:www-data /var/log/apache2
else
echo "moving bgpanel files"
cp -pr /root/bgp_r0-devel-beta8/bgpanel /var/www/
chown -R www-data:www-data /var/www/bgpanel
fi
crontab /root/cronjob
