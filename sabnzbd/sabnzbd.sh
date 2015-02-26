#!/bin/bash

exec /sbin/setuser nobody /usr/bin/sabnzbdplus --config-file /config --server 0.0.0.0:8080
