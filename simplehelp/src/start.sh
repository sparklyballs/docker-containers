#!/bin/bash

exec /sbin/setuser nobody /opt/SimpleHelp/jre1.6.0_16/bin/java -Xmx384m -Djava.net.preferIPv4Stack=true -cp "lib/secure_shelp.jar:lib/secure_utils.jar:lib/secure_nlink.jar:lib/mail.jar:lib/activation.jar" -Djava.awt.headless=true SecureRunner1 com.aem.shelp.proxy.ProxyServerStartup &
