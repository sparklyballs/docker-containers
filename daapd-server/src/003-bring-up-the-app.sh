#!/bin/bash
exec /usr/bin/supervisord -c /root/supervisord.conf & > /dev/null 2>&1 
