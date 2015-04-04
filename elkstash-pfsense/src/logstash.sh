#!/bin/bash

exec /sbin/setuser nobody /opt/logstash/bin/logstash agent -f /config/logstash-conf -l /config/elasticsearch-data/log/logstash.log

