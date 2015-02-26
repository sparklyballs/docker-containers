#!/bin/bash
if [ -f "/var/www/unmark/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching unmark files"
cd /var/www/
git clone https://github.com/plainmade/unmark
cd unmark
cp application/config/database-sample.php application/config/database.php
chown -R www-data:www-data /var/www/unmark
fi

