#!/bin/bash
if [ ! -f "/config/forked-daapd.conf" ]; then
cp /root/forked-daapd.conf /config/forked-daapd.conf
fi
if [ ! -d "/config/logs-databases-and-cache" ]; then
mkdir -p /config/logs-databases-and-cache
fi
if [ ! -d "/forked-daap-pid" ]; then
mkdir -p /forked-daap-pid
fi
chown -R nobody:users /config /forked-daap-pid
