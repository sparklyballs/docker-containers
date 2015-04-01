#!/bin/bash

if [ -d "/config/logstash-conf" ] ; then
echo "using existing config files"
else 
echo "copying default config files, edit and restart container"
cp -r /root/logstash-conf /config
fi

if [ -d "/config/dashboards" ] ; then
echo "using existing dashboards"
cp -r /config/dashboards/* /usr/share/nginx/html/app/dashboards/
else
echo "using default dashboards"
cp -r /root/dashboards /config
fi
