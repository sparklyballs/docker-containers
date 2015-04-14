#!/bin/bash
# Does the user want the edge version
if [ -z "$EDGE" ]; then
echo "edge not requested"
else
cd /opt/HTPC-Manager
git pull
fi
