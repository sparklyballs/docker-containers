#!/bin/bash
if [ -f "/config/dcm4/dcm4chee/dcm4chee-mysql/bin/run.sh" ]; then
echo "using existing setup"
chown -R nobody:users /config
else
echo "creating new setup"
cp -pr /root/temp-setup/dcm4chee/ /config/dcm4/
chown -R nobody:users /config
sleep 10
fi

rm -rf /var/local/mysql/*.pid
if [ -d "/config/databases/arrdb" ]; then
echo "Using existing databases"
chown -R nobody:users /config
/usr/bin/supervisord
sleep 20s
else
echo "new setup, copying empty databases"
cp -pr /var/lib/mysql/* /config/databases/
chown -R nobody:users /config
sleep 10s
/usr/bin/supervisord
sleep 20s
fi
