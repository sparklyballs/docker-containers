#!/bin/bash
if [ -d "/opt/gamezserver/.git" ]; then
cd /opt/gamezserver
git checkout master
else
git clone https://github.com/mdlesk/GamezServer /opt/gamezserver
fi

chown -R nobody:users /opt/gamezserver
exec /sbin/setuser nobody python /opt/gamezserver/GamezServer.py &
