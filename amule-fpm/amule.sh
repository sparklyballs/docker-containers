#!/bin/bash
exec /sbin/setuser nobody /opt/amule/amule/bin/bin/amuled -c /config -f /opt/amule/amule/bin/bin/amuled -c /config -f --use-amuleweb=/opt/amule/amule/bin/bin/amuleweb

