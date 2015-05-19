#!/bin/sh
BRAINZCODE="what a  test fucke343t4354tregergrwrr" 
SANEDBRAINZCODE1="${BRAINZCODE#"${BRAINZCODE%%[![:space:]]*}"}"
SANEDBRAINZCODE="${SANEDBRAINZCODE1%"${SANEDBRAINZCODE1##*[![:space:]]}"}"
sed -i "s|\(sub REPLICATION_ACCESS_TOKEN\ {\ \\\"\)[^<>]*\(\\\"\ }\)|\1${SANEDBRAINZCODE}\2|" /home/sparklyballs/DBDdefs.pm
