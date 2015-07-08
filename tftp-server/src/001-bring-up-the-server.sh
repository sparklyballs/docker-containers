#!/bin/bash
chown root:root/images
exec /usr/bin/supervisord -c /root/supervisord.conf
