#!/bin/bash

exec /sbin/setuser nobody python /opt/sickbeard/SickBeard.py --datadir=/config/sickbeard >/dev/null 2>&1

