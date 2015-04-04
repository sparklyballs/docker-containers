#!/bin/bash

mkdir -p /config/elasticsearch-data/log
if [ -d "/var/log/kibana" ]; then
chown -R www-data:www-data /var/www/kibana
echo "using existing www files"
else
cp -r /root/kibana-temp/* /var/www/
chown -R www-data:www-data /var/www/kibana
fi

if [ -d "/config/dashboards" ]; then
echo "using existing dashboards"
mv /var/www/kibana/app/dashboards/default.json /var/www/kibana/app/dashboards/original.json
cp -r /config/dashboards/* /var/www/kibana/app/dashboards/
chown -R www-data:www-data /var/www/kibana
else
mkdir -p /config/dashboards
cp -r /root/dashboards /config/
cp -r /config/dashboards/* /var/www/kibana/app/dashboards/
chown -R www-data:www-data /var/www/kibana
fi

if [ -d "/config/logstash-conf" ]; then
echo "using existing config folder"
else
cp -r /root/logstash-conf /config/
fi

chown -R nobody:users /config
