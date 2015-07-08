#!/bin/bash
exec /usr/sbin/in.tftpd --foreground --ipv4 --user nobody --address 0.0.0.0:69 --secure /images
