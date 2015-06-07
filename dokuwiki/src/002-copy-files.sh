#!/bin/bash
mkdir -p /var/www/dokuwiki
if [ -f "/var/www/dokuwiki/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2 /var/www/dokuwiki
else
echo "copying dokuwiki files"
cp -pr /root/dokuwiki/*  /var/www/dokuwiki/
chown -R www-data:www-data /var/www/dokuwiki
fi
