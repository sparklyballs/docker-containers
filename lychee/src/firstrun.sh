#!/bin/bash
mkdir -p /config
if [ -f "/var/www/Lychee/index.html" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching Lychee files"
git clone https://github.com/electerious/Lychee.git /var/www/Lychee
chown -R www-data:www-data /var/www/Lychee
fi

