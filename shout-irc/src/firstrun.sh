#!/bin/bash

if [ -f "/config/config.js" ]; then
echo "using saved config file"
else
cp /root/config.js /config/config.js
chown -R nobody:users /config
sleep 5s
fi
