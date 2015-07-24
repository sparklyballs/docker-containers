#!/bin/bash
if [ ! -f "/minetest/minetest.conf" ]; then
cp /root/minetest.conf /minetest/minetest.conf
fi 

chown -R nobody:users /minetest
