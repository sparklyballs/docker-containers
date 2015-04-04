#!/bin/bash

# Kill any preexisting mysql pid
rm -rf /var/local/mysql/*.pid

## Make installation folders using environment variables from dockerfile
mkdir -p $DBASE_DATA 
mkdir -p $DCM4CHEE_HOME

# Set test and copy variables 
DBASE_DEST=$DBASE_DATA/
DBASE_EXIST_TEST=$DBASE_DATA/arrdb 
DCMRUN_TEST=$DCM4CHEE_HOME$DCM_RUN
# Test for existing dcm4chee installation
if [ -f $DCMRUN_TEST ]; then
echo "using existing setup"
chown -R nobody:users $DCM4CHEE_HOME
chmod -R 777 $DCM4CHEE_HOME
else
echo "creating new setup"
cp -pr /root/temp-setup/dcm4chee/* $DCM4CHEE_HOME/
chown -R nobody:users $DCM4CHEE_HOME
chmod -R 777 $DCM4CHEE_HOME
sleep 10
fi

# Test for existing database installation and run supervisord
if [ -d $DBASE_EXIST_TEST ]; then
echo "Using existing databases"
chown -R nobody:users $DBASE_DATA
chmod -R 777 $DBASE_DATA
/usr/bin/supervisord
sleep 20s
else
echo "new setup, copying empty databases"
cp -pr /var/lib/mysql/* $DBASE_DEST
chown -R nobody:users $DBASE_DATA
chmod -R 777 $DBASE_DATA
sleep 10s
/usr/bin/supervisord
sleep 20s
fi
