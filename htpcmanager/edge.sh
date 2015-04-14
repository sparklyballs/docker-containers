#!/bin/bash
# Does the user want the edge version
if [ -z "$EDGE" ]; then
echo "edge not requested"
else
cd /opt/HTPC-Manager
git pull
chown -R nobody:users /opt/HTPC-Manager
fi
