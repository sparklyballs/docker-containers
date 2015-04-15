#!/bin/bash
if [ -f "/var/www/Jirafeau/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching freshress files"
git clone https://gitlab.com/mojo42/Jirafeau.git /var/www/Jirafeau
chown -R www-data:www-data /var/www/Jirafeau
fi

