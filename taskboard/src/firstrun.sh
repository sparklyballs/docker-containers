#!/bin/bash
mkdir -p /config
if [ -f "/var/www/TaskBoard/index.html" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching Taskboard files"
git clone https://github.com/kiswa/TaskBoard.git  /var/www/TaskBoard
chown -R www-data:www-data /var/www/TaskBoard
chmod -R 777 /var/www/TaskBoard/api
fi

