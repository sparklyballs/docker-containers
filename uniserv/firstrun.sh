#!/bin/bash
if [ -f "/opt/ums/UMS.sh" ]; then
echo "using existing files"
else
echo "copying program files to opt/ums"
mkdir -p /opt/ums
cp -pr /root/ums-5.1.4/* /opt/ums
fi
