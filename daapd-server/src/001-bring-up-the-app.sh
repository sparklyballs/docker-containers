#!/bin/bash
if [ ! -f "/config/avahi-daemon.conf" ]; then
cp /root/avahi-daemon.conf /config/avahi-daemon.conf
fi
if [ ! -f "/config/forked-daapd.conf" ]; then
cp /root/forked-daapd.conf /config/forked-daapd.conf
fi
if [ ! -d "/config/logs-databases-and-cache" ]; then
mkdir -p /config/logs-databases-and-cache
fi
chown -R root:root /config/logs-databases-and-cache
chown nobody:users /config/forked-daapd.conf /config/avahi-daemon.conf
exec /usr/bin/supervisord -c /root/supervisord.conf & > /dev/null 2>&1 
