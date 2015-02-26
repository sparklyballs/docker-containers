#!/bin/bash

exec /sbin/setuser nobody python /opt/sickbeard/SickBeard.py --datadir=/config
