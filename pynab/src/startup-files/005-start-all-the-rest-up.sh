#!/bin/bash
mkdir -p /data/pynab-logs
chmod -R 777 /data/pynab-logs
/usr/bin/supervisord -c /root/supervisor-files/nginx-pynab-supervisord.conf &
