#!/bin/bash
# Does the user want the latest version
if [ -z "$EDGE" ]; then
echo "Bleeding edge not requested"
else
cd /opt/sickbeard
git pull
chown -R nobody:users /opt/sickbeard
fi
