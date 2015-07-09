#!/bin/bash
if [ ! -f "/config/forked-daapd.conf" ]; then
cp /root/forked-daapd.conf /config/forked-daapd.conf
fi
chown nobody:users /config/forked-daapd.conf
exec /usr/bin/supervisord -c /root/supervisord.conf > /dev/null 2>&1
