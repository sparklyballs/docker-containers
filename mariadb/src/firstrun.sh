#!/bin/bash
if [ -f "/db/my.cnf" ]; then
echo "applying latest my.cnf"
/bin/cp -f /db/my.cnf /etc/mysql/my.cnf
chown root:root /etc/mysql/my.cnf
else
echo "copying initial my.cnf from root dir"
/bin/cp -f /root/my.cnf /db/my.cnf
/bin/cp -f /db/my.cnf /etc/mysql/my.cnf
chown root:root /etc/mysql/my.cnf
fi
chown -R nobody:users /db
