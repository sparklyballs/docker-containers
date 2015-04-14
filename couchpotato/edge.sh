#!/bin/bash

# Does the user want the latest version
if [ -z "$EDGE" ]; then
  echo "Bleeding edge not requested"
else
  cd /opt/couchpotato
  git pull
  chown -R nobody:users /opt/couchpotato
fi
