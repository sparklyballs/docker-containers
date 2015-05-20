#!/bin/bash
mkdir -p /opt/serviio
if [ -d "/opt/serviio/config" ]; then
echo "using existing serviio files"
usr/bin/supervisord -c /root/supervisord.conf &
else
cp -pr /root/serviio/* /opt/serviio/
usr/bin/supervisord -c /root/supervisord.conf &
fi
