#!/bin/bash
apt-get install -y wget
rm -rf /import/*
wget -nd -nH -P /import ftp://ftp.musicbrainz.org/pub/musicbrainz/data/fullexport/LATEST
LATEST=$(cat /media/dbdump/LATEST)
wget -r --no-parent -nd -nH -P /import --reject "index.html*, mbdump-edit*, mbdump-documentation*" "ftp://ftp.musicbrainz.org/pub/musicbrainz/data/fullexport/$LATEST"
pushd /import && md5sum -c MD5SUMS && popd
/opt/musicbrainz/admin/InitDb.pl --createdb --import /media/dbdump/mbdump*.tar.bz2 --echo

