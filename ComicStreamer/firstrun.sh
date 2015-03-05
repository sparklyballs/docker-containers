#!/bin/bash
if [ -d "/opt/comicstreamer" ]; then
echo "using existing installation"
else
echo "pulling comicstreamer from git"
git clone https://github.com/beville/ComicStreamer.git  /opt/comicstreamer
sleep 5
fi
