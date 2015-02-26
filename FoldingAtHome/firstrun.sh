#!/bin/bash
chown -R nobody:users /config

# Check if config exists. If not, copy in the sample config
if [ -f /config/config.xml ]; then
  chown nobody:users /config/config.xml
  chmod 777 /config/config.xml
  echo "Using existing config file."

  else

  echo "Creating config from template."
  cp  /root/config.xml /config/config.xml
  chown nobody:users /config/config.xml
  chmod 777 /config/config.xml
fi

if [ -d /config/work ]; then
echo "Cleaning empty work unit folders"
find /config/work -depth -type d -empty -exec rmdir {} \;
else 
echo "work area is empty and ready for folding"
fi
