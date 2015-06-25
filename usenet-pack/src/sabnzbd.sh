#!/bin/bash

exec /sbin/setuser nobody /usr/bin/sabnzbdplus --config-file /config/sabnzbd --server 0.0.0.0:8080 >/dev/null 2>&1

