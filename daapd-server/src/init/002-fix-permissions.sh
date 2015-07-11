#!/bin/bash
PUID=99
PGID=100
if [ ! "$(id -u daapd)" -eq "$PUID" ]; then usermod -u "$PUID" daapd; fi
if [ ! "$(id -g daapd)" -eq "$PGID" ]; then groupmod -o -g "$PGID" daapd ; fi
