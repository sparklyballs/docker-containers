#!/bin/bash
mkdir -p /opt/ghost
if [ -f "/opt/ghost/index.js" ]; then
echo "ghost appears to be set"
else
cp -pr /root/ghost/* /opt/ghost/
chown -R nobody:users /opt/ghost
fi
sleep 5s
/usr/bin/supervisord -c /root/supervisord.conf &
