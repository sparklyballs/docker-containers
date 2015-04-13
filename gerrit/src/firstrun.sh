#!/bin/bash
chown -R nobody:users /opt/gerrit
if [ -d "/opt/gerrit/bin" ]; then
echo "gerrit files already in place"
chown -R nobody:users /opt/gerrit
exec /usr/bin/supervisord
else
/sbin/setuser nobody java -jar $GERRIT_WAR init --batch -d $GERRIT_HOME
cp /root/gerrit.config /opt/gerrit/etc/gerrit.config
chown -R nobody:users /opt/gerrit
sleep 15s
fi
