#!/bin/bash
if [ -f "/config/amule.conf" ]; then
echo "using existing config"
else
cp /root/conf/* /config/
fi
sleep 10
chown -R nobody:users /config
/usr/bin/supervisord
