#!/bin/bash
if [ -f "/config/config.js" ]; then
echo "config.js exists in /config, may require editing"
cp /config/config.js /opt/pynab/webui/app/scripts/config.js
else
cp /root/config-files/config.js /config/config.js
fi
if [ -f "/config/config.py" ]; then
echo "config.py exists in /config, may require editing"
cp /config/config.py /opt/pynab/
else
cp /root/config-files/config.py /config/config.py
fi
if [ ! -f "/config/groups.json" ]; then
cp /root/config-files/groups.json /config/groups.json
else
echo "groups.json exists in /config, may require editing"
fi
sed -i "/# 'http:\/\/www.newznab.com\/getregex.php?newznabID=<id>'/{n;s^.*^    'regex_url': '${regex_url}',^}" /config/config.py
sed -i "/# host: your usenet server host ('news.supernews.com' or the like)/{n;s^.*^    'host': '${news_server}',^}" /config/config.py
sed -i "/# user: whatever your login name is/{n;s/.*/    'user': '${news_user}',/}" /config/config.py
sed -i "/# password: your password/{n;s/.*/    'password': '${news_passwd}',/}" /config/config.py
sed -i "/# make sure there aren't any quotes around it/{n;s/.*/    'port':${news_port},/}" /config/config.py
if [ "$news_ssl" -eq 0 ]; then
ssl_condition="False"
else
ssl_condition="True"
fi
sed -i "/# ssl: True if you want to use SSL, False if not/{n;s/.*/    'ssl': ${ssl_condition},/}" /config/config.py
if [ "$backfill_days" -eq 0 ]; then
binary_age="3"
else
binary_age="0"
fi
sed -i "s|\('dead_binary_age': \)[^<>]*\(,\)|\1${binary_age}\2|" /config/config.py
sed -i "s|\('backfill_days': \)[^<>]*\(,\)|\1${backfill_days}\2|" /config/config.py
cp /config/config.py /opt/pynab/config.py
cp /config/config.js /opt/pynab/webui/app/scripts/config.js
chown nobody:users /config/config.py /config/config.js
chown -R www-data:www-data /opt/pynab
