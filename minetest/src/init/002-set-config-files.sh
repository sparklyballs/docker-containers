#!/bin/bash
mkdir -p /config/.minetest/main-config
if [ ! -f "/config/.minetest/main-config/minetest.conf" ]; then
cp /root/minetest.conf /config/.minetest/main-config/minetest.conf
fi 

if [ ! -d "/opt/minetest/share/minetest/games/minetest" ]; then
cp -pr /games/* /opt/minetest/share/minetest/games/
fi
chown -R minetest:users /config /opt/minetest
