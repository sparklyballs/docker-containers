#!/bin/bash
rm -rf /var/local/mysql/*.pid
if [ -f "/DATABASE/arrdb/active_part.frm" ]; then
echo "Using existing databases"
chown -R nobody:users /DATABASE
else
echo "new setup, copying empty databases"
cp -pr /var/lib/mysql/* /DATABASE/
chown -R nobody:users /DATABASE
sleep 10s 
fi
