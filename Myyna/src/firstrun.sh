#!/bin/bash
mkdir -p /config/mongo
if [ -f "/config/myyna/app.js" ]; then
echo "using existing website"
else
echo "fetching myyna files"
cp -pr /root/myyna /config/myyna
sleep 10
fi
