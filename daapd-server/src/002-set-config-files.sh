#!/bin/bash
if [ ! -f "/config/forked-daapd.conf" ]; then
cp /root/forked-daapd.conf /config/forked-daapd.conf
fi
if [ ! -d "/config/logs-databases-and-cache" ]; then
mkdir -p /config/logs-databases-and-cache
fi
chown -R root:root /config/logs-databases-and-cache
chown nobody:users /config/forked-daapd.conf
