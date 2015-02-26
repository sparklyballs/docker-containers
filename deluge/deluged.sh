#!/bin/bash

exec /sbin/setuser nobody deluged -d -c /config -L info -l /config/deluged.log
