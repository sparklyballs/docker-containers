#!/bin/bash
if [ -d "/opt/kodi-server/share/kodi/portable_data/userdata" ]; then
echo "using existing datafiles"
chown -R nobody:users /opt/kodi-server
else
echo "creating datafiles"
mkdir -p /opt/kodi-server/share/kodi/portable_data/userdata
sleep 15
chown -R nobody:users /opt/kodi-server
fi
if [ -f "/opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml" ]; then
echo "using existing advancedsettings.xml"
chown -R nobody:users /opt/kodi-server
sed -i "s|\(<host>\)[^<>]*\(</host>\)|\1${MYSQLip}\2|" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
sed -i "s|\(<port>\)[^<>]*\(</port>\)|\1${MYSQLport}\2|" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
sed -i "s|\(<user>\)[^<>]*\(</user>\)|\1${MYSQLuser}\2|" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
sed -i "s|\(<pass>\)[^<>]*\(</pass>\)|\1${MYSQLpass}\2|" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
else
echo "creating advancedsettings.xml"
cp /root/advancedsettings.xml /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
chown -R nobody:users /opt/kodi-server
sed -i "s|\(<host>\)[^<>]*\(</host>\)|\1${MYSQLip}\2|" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
sed -i "s|\(<port>\)[^<>]*\(</port>\)|\1${MYSQLport}\2|" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
sed -i "s|\(<user>\)[^<>]*\(</user>\)|\1${MYSQLuser}\2|" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
sed -i "s|\(<pass>\)[^<>]*\(</pass>\)|\1${MYSQLpass}\2|" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
fi
