#!/bin/sh
while inotifywait -r -e create /config; do
/bin/bash /root/runsql-script
echo "Applying sql commands"
done
