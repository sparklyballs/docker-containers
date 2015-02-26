#!/bin/bash
# Does the user want the latest version
if [ -z "$EDGE" ]; then
echo "Bleeding edge not requested"
else
rm -rf /opt/sickbeard
git clone https://github.com/midgetspy/Sick-Beard.git /opt/sickbeard
chown -R nobody:users /opt/sickbeard
fi
