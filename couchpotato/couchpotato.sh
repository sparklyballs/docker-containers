#!/bin/bash

exec /sbin/setuser nobody python /opt/couchpotato/CouchPotato.py --config_file=/config/settings.conf --data_dir=/config/data > /dev/null 2>&1
