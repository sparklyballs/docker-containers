#!/bin/bash
# Does the user want the latest version
if [ -z "$EDGE" ]; then
echo "Bleeding edge not requested"
else
cd /opt/headphones
git pull
chown -R nobody:users /opt/headphones
fi
