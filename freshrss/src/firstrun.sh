#!/bin/bash
mkdir -p /var/www/freshrss
if [ -f "/var/www/freshrss/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
echo "fetching freshress files"
cd /var/www/freshrss
wget https://github.com/marienfressinaud/FreshRSS/archive/master.zip
unzip master.zip
mv FreshRSS-master/* .
rm -R FreshRSS-master/ master.zip
chown -R www-data:www-data /var/www/freshrss
fi
crontab /root/cronjob

