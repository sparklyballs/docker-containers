#!/bin/bash

exec /sbin/setuser nobody /opt/SimpleHelp//jre1.6.0_16/bin/java -Xmx384m -Djava.net.preferIPv4Stack=true -cp "/opt/SimpleHelp//lib/secure_shelp.jar:/opt/SimpleHelp//lib/secure_utils.jar:/opt/SimpleHelp//lib/secure_nlink.jar:/opt/SimpleHelp//lib/mail.jar:/opt/SimpleHelp//lib/activation.jar" -Djava.awt.headless=true SecureRunner1 com.aem.shelp.proxy.ProxyServerStartup &

