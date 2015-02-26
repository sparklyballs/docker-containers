#!/bin/bash
# Does the user want the edge version
if [ -z "$EDGE" ]; then
echo "edge not requested"
else
rm -rf /opt/HTPC-Manager
git clone -b master https://github.com/styxit/HTPC-Manager.git /opt/HTPC-Manager
fi
