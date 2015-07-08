#!/bin/bash
exec /usr/sbin/in.tftpd --foreground --user tftp --address 0.0.0.0:69 --secure /images
