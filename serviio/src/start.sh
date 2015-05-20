#!/bin/bash
cd /opt/serviio/bin
/usr/lib/jvm/java-8-oracle/bin/java -Xmx512M -Xms20M -XX:+UseG1GC -XX:GCTimeRatio=1 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dorg.restlet.engine.loggerFacadeClass=org.restlet.ext.slf4j.Slf4jLoggerFacade -Dderby.system.home=/opt/serviio/library -Dserviio.home=/opt/serviio -Dffmpeg.location=/usr/bin/ffmpeg -Ddcraw.location=/usr/bin/dcraw -classpath /opt/serviio/lib/*:/opt/serviio/config org.serviio.MediaServer

