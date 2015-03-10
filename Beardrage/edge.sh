#!/bin/bash
# Does the user want sickrage or sickbeard, if edge set 1 this selects version and path to update
if [ "$SICKRAGE" -eq 0 ]; then
sickdir="/opt/sickbeard"
sickgit="https://github.com/midgetspy/Sick-Beard.git"
else
sickdir="/opt/sickrage"
sickgit="https://github.com/SiCKRAGETV/SickRage.git"
fi
# Does the user want the latest version
if [ "$EDGE" -eq 0 ]; then
echo "Bleeding edge not requested"
else
rm -rf $sickdir
git clone $sickgit  $sickdir
chown -R nobody:users $sickdir
fi
