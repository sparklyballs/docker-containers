#!/bin/bash
if [ -f "/config/amule.conf" ]; then
echo "using existing config"
else 
cp /root/*.conf /config/
fi
chown -R nobody:users /config

