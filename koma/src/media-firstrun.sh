#!/bin/bash
chown -R nobody:users /config
if [ -d "/opt/kodi-server/share/kodi/portable_data/userdata" ]; then
echo "using existing datafiles"
chown -R nobody:users /opt/kodi-server
else
echo "creating datafiles"
mkdir -p /opt/kodi-server/share/kodi/portable_data/userdata
sleep 15
chown -R nobody:users /opt/kodi-server
chown -R nobody:users /config
chmod -R 755 /config
fi
if [ -f "/opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml" ]; then
echo "using existing advancedsettings.xml"
chown -R nobody:users /opt/kodi-server
else
echo "creating advancedsettings.xml"
cp /root/advancedsettings.xml /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
chown -R nobody:users /opt/kodi-server
fi
