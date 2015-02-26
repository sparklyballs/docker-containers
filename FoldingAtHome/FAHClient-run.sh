#!/bin/bash
cd /config
exec /sbin/setuser nobody /opt/fah/usr/bin/FAHClient --config /config/config.xml
