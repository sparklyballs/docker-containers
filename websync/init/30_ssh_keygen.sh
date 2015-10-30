#!/bin/bash

mkdir -p /config/keys /app/.ssh
chown abc:abc /app/.ssh

if [ ! -f /config/keys/id_rsa -o  ! -f /config/keys/id_rsa.pub ]; then
/sbin/setuser abc ssh-keygen -t rsa -N "" -f /app/.ssh/id_rsa
cp /app/.ssh/* /config/keys
else
cp /config/keys/id_rsa.pub /config/keys/id_rsa /app/.ssh/
fi

