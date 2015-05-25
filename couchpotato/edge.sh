#!/bin/bash

# Does the user want the latest version
if [ -z "$EDGE" ]; then
  echo "Bleeding edge not requested"
else
  cd /opt/couchpotato
  echo "pulling updates from git"
  git pull > /dev/null 2>&1
  echo "pull complete"
  chown -R nobody:users /opt/couchpotato
fi
