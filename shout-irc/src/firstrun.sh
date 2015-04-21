#!/bin/bash

if [ -f "/config/config.js" ]; then
echo "using saved config file"
else
cp /usr/local/lib/node_modules/shout/defaults/config.js /config/config.js
chown -R nobody:users /config/config.js
chmod -R 777 /config/config.js
sleep 5s
fi
