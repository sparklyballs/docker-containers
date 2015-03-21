#!/bin/bash
if [ -f "/DICOM/dcm4chee/dcm4chee-mysql/bin/run.sh" ]; then
echo "using existing setup"
chown -R nobody:users /DICOM
else
echo "creating new setup"
cp -pr /root/temp-setup/dcm4chee/ /DICOM/
chown -R nobody:users /DICOM
sleep 10
fi

rm -rf /var/local/mysql/*.pid
if [ -d "/DATABASE/arrdb" ]; then
echo "Using existing databases"
chown -R nobody:users /DATABASE
/usr/bin/supervisord
sleep 20s
else
echo "new setup, copying empty databases"
cp -pr /var/lib/mysql/* /DATABASE/
chown -R nobody:users /DATABASE
sleep 10s
/usr/bin/supervisord
sleep 20s
fi
