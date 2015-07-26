#!/bin/bash
mkdir -p /config
if [ ! -f "/config/minetest.conf" ]; then
cp /root/minetest.conf /config/minetest.conf
fi 

if [ ! -d "/opt/minetest/share/minetest/games/minetest" ]; then
cp -pr /games/* /opt/minetest/share/minetest/games/
fi
chown -R minetest:users /config /opt/minetest
