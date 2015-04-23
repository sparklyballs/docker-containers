#!/bin/bash

if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
fi

if [ -d "/opt/SimpleHelp/lib" ]; then
echo "simplehelp files are in place"
else
mkdir -p /opt/SimpleHelp
cp -r /root/SimpleHelp/* /opt/SimpleHelp/
fi

sleep 5s
exec /usr/bin/supervisord
