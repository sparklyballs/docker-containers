#!/bin/bash

exec /sbin/setuser nobody /opt/elasticsearch/bin/elasticsearch -Des.default.path.logs=/config/elasticsearch-data/log -Des.default.path.data=/config/elasticsearch-data -Des.default.path.work=/tmp/elasticsearch


