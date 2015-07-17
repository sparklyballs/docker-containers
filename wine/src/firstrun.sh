#!/bin/bash

if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
fi

mkdir -p /home/ubuntu
chown -R ubuntu:users /home/ubuntu/
mkdir  -p /var/run/sshd
mkdir  -p /root/.vnc
/usr/bin/supervisord -c /root/supervisord.conf
while [ 1 ]; do
/bin/bash
done
