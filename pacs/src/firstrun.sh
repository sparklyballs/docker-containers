#!/bin/bash
if [ -f "/DICOM/dcm4chee/dcm4chee-2.17.1-mysql/bin/run.sh" ]; then
echo "using existing setup"
chown -R nobody:users /DICOM
else
echo "creating new setup"
cp -pr /root/temp-setup/dcm4chee/ /DICOM/
chown -R nobody:users /DICOM
sleep 10
fi
