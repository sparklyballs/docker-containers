#!/bin/bash
# Does the user want sickrage or sickbeard, if edge set 1 this selects version and path to update
if [ "$SICKRAGE" -eq 0 ]; then
sickrun="/opt/sickbeard/SickBeard.py"
sickconf="/config/SickBeard"
else
sickrun="/opt/sickrage/SickBeard.py"
sickconf="/config/SickRage"
fi
chown -R nobody:users /config
exec /sbin/setuser nobody python $sickrun --datadir $sickconf
