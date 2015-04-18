#!/bin/bash

mkdir -p /opt/yify-pop

if [ -f "/opt/yify-pop/app" ]; then
echo "yify-pop files are already in place"
else
cp -pr /root/yify-pop/* /opt/yify-pop/
cd /opt/yify-pop
npm install
sleep 10s
fi

exec /usr/bin/supervisord
