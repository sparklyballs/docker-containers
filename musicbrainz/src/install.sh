#!/bin/bash

# Set the locale
locale-gen en_US.UTF-8

# update apt and install wget
apt-get update -qq 
apt-get install -y wget

# add postgresql repo
wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# update apt again and install postgresql
apt-get update -qq
apt-get install postgresql-client-9.4 postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib-9.4 postgresql-plperl-9.4 -y

# install git-core, memcached and redis-server
apt-get install git-core memcached redis-server -y

# install nodejs and npm
apt-get install nodejs npm nodejs-legacy -y

# install build essential, screen  and supervisor
apt-get install build-essential screen supervisor -y

# fetch source from git
cd /root
git clone --recursive git://github.com/metabrainz/musicbrainz-server.git 
cd musicbrainz-server


# install perl dependencies
apt-get install python-software-properties software-properties-common libxml2-dev libpq-dev libexpat1-dev libdb-dev libicu-dev liblocal-lib-perl cpanminus -y
