#!/bin/bash


if [ -f "/home/mythtv/.config/autostart/mythbackend.desktop"]; then
echo "mythbackend autostart file already in place"
else
mkdir -p /home/mythtv/.config/autostart
cp /root/mythbackend.desktop /home/mythtv/.config/autostart/mythbackend.desktop
fi

if [ -f "/home/mythtv/.mythtv/config.xml" ]; then
echo "default config file(s) appear to be in place"
else
mkdir -p /home/mythtv/.mythtv
cp /root/config.xml /root/.mythtv/config.xml
cp /root/config.xml /usr/share/mythtv/config.xml
cp /root/config.xml /etc/mythtv/config.xml
cp /root/config.xml /home/mythtv/.mythtv/config.xml
fi

if [ -f "/home/mythtv/.Xauthority" ]; then
echo ".Xauthority file appears to in place"
else
touch /home/mythtv/.Xauthority
fi

if [ -d "/var/lib/mythtv/banners" ]; then
echo "mythtv folders appear to be set"
else
mkdir -p /var/lib/mythtv/banners  /var/lib/mythtv/coverart  /var/lib/mythtv/db_backups  /var/lib/mythtv/fanart  /var/lib/mythtv/livetv  /var/lib/mythtv/recordings  /var/lib/mythtv/screenshots  /var/lib/mythtv/streaming  /var/lib/mythtv/trailers  /var/lib/mythtv/videos
fi

chown -R mythtv:users /var/lib/mythtv/banners  /var/lib/mythtv/coverart  /var/lib/mythtv/db_backups  /var/lib/mythtv/fanart  /var/lib/mythtv/livetv  /var/lib/mythtv/recordings  /var/lib/mythtv/screenshots  /var/lib/mythtv/streaming  /var/lib/mythtv/trailers  /var/lib/mythtv/videos /home/mythtv

