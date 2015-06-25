#!/bin/bash

if [ -d "/config/couchpotato" ]; then
echo "folders appear set"
else
mkdir -p /config/htpcmanager /config/couchpotato /config/sabnzbd /config/sickbeard /downloads/incomplete /downloads/movies /downloads/tv-shows
chown -R nobody:users /config /downloads
SAB_API_KEY=$(< /dev/urandom tr -dc a-z0-9  | head -c${1:-32})
fi

if [ -f "/config/sabnzbd/sabnzbd.ini" ]; then
echo "sabnzbd config file appears to be set"
else
cp /root/config-files/sabnzbd.ini  /config/sabnzbd/sabnzbd.ini
sed -i  "/create_group_folders = 0/{n;s/.*/api_key =${SAB_API_KEY}/}" /config/sabnzbd/sabnzbd.ini
fi

if [ -f "/config/sickbeard/config.ini" ]; then
echo "sickbeard config file appears set"
else
cp /root/config-files/config.ini /config/sickbeard/config.ini
sed -i -e "s@sab_apikey.*@sab_apikey = \"${SAB_API_KEY}\"@g" /config/sickbeard/config.ini
fi

if [ -f "/config/couchpotato/settings.conf" ]; then
echo "couchpotato config file appears set"
else
cp /root/config-files/settings.conf /config/couchpotato/settings.conf
fi

chown -R nobody:users /config


