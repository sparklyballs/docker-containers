#!/bin/bash
if [ -f "/home/mythtv/.mythtv/config.xml" ]; then
echo "default config file(s) appear to be in place"
else
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

chown -R mythtv:users /home/mythtv

