#!/bin/bash

if [ -d "/var/lib/mythtv/banners" ]; then
echo "mythtv folders appear to be set"
else
mkdir -p /var/lib/mythtv/banners  /var/lib/mythtv/coverart  /var/lib/mythtv/db_backups  /var/lib/mythtv/fanart  /var/lib/mythtv/livetv  /var/lib/mythtv/recordings  /var/lib/mythtv/screenshots  /var/lib/mythtv/streaming  /var/lib/mythtv/trailers  /var/lib/mythtv/videos
fi
exec /usr/sbin/apache2ctl -D FOREGROUND
