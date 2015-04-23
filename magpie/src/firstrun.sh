#!/bin/bash

if [ -d "/config/git/.git" ]; then
echo "save area already configured"
else 
mkdir -p /config
cd /config
git init
chown -R nobody:users /config
mv /usr/local/lib/python2.7/dist-packages/magpie/config/web.cfg /usr/local/lib/python2.7/dist-packages/magpie/config/web.original
cp /root/web.cfg /usr/local/lib/python2.7/dist-packages/magpie/config/web.cfg
chown -R nobody:users /usr/local/lib/python2.7/dist-packages/magpie
fi

