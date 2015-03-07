#!/bin/bash
if [ -f "/var/www/sonerezh/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching sonerezh files"
cd /var/www
git clone http://github.com/Sonerezh/sonerezh.git
chown -R www-data:www-data /var/www/sonerezh
fi

