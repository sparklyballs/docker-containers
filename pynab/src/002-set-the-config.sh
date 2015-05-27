#!/bin/bash

if [ -f "/config/config.py" ]; then
echo "config files exist in /config, may require editing"
cp /config/config.py /opt/pynab/
else
cp /root/config-files /config/config.py
fi
cp /config/config.py /opt/pynab/
chown nobody:users /config/config.py
chown -R www-data:www-data /opt/pynab
