#!/bin/bash
mkdir -p /opt/serviio
if [ -d "/opt/serviio/config" ]; then
echo "using existing serviio files"
else
cp -pr /root/serviio/* /opt/serviio/
usr/bin/supervisord -c /root/supervisord.conf &
fi
