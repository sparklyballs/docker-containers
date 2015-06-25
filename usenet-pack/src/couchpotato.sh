#!/bin/bash

exec /sbin/setuser nobody python /opt/couchpotato/CouchPotato.py --config_file=/config/couchpotato/settings.conf --data_dir=/config/couchpotato/data > /dev/null 2>&1 

