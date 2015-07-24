#!/bin/bash
if [ ! -f "/home/minetest/.minetest/minetest.conf" ]; then
cp /root/minetest.conf /home/minetest/.minetest/minetest.conf
fi 

chown -R minetest:minetest /home/minetest/.minetest/
