#!/bin/bash
exec /usr/bin/supervisord -c /root/config-files/supervisord.conf & > /dev/null 2>&1 
