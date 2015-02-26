#!/bin/bash

exec /sbin/setuser nobody python /opt/sickrage/SickBeard.py --datadir=/config
