#!/bin/bash

if [ -d "/usr/local/lib/node_modules/shout/defaults" ]; then
echo "shout is already installed"
else
npm install -g shout
chown -R nobody:users /usr/local/lib/node_modules/shout
fi
