#!/bin/bash
exec 2>&1
cd /noVNC
exec python /noVNC/utils/websockify --web /noVNC 6080 localhost:5900
