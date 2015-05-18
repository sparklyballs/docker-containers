#!/bin/bash


mkdir -p /opt/serviio
if [ -d "/opt/serviio/config" ]; then
echo "using existing serviio files"
else
cp -pr /root/serviio/* /opt/serviio/

cd /opt/serviio/bin
exec ./serviio.sh
