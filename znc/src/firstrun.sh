#!/bin/bash
mkdir -p /config/configs
if [ ! -f "/config/znc.pem" ]; then
/usr/local/bin/znc -d /config -p
fi
while [ ! -f "/config/znc.pem" ]; do
echo "waiting for pem file to be generated"
sleep 1s
done
if [ ! -f "/config/configs/znc.conf" ]; then
cp /root/znc.conf /config/configs/znc.conf
fi
chown -R nobody:users /config
exec /usr/bin/supervisord -c /root/supervisord.conf
