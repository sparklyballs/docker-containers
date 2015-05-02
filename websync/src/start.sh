#!/bin/bash
chown -R root:root /nobody
cd /nobody/websync/dist
node server.js
