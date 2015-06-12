#!/bin/bash
if [ -f "/config/my.cnf" ]; then
echo "applying latest my.cnf"
/bin/cp -f /config/my.cnf /etc/mysql/my.cnf
chown root:root /etc/mysql/my.cnf
else
echo "copying initial my.cnf from root dir"
/bin/cp -f /etc/mysql/my.cnf /config/my.cnf
fi
chown -R nobody:users /config
