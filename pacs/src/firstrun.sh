#!/bin/bash
if [ -f "/DICOM/dcm4chee/dcm4chee-2.17.1-mysql/bin/run.sh" ]; then
echo "using existing setup"
else
echo "creating new setup"
cp -pr /root/temp-setup/ /DICOM/
sleep 10
fi
