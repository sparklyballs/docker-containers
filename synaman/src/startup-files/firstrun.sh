#!/bin/bash

if [ -d "/opt/SynaMan" ]; then
echo "SynaMan files are in place"
else
cp -r /root/temp/SynaMan /opt/
chown -R nobody:users /opt
fi

