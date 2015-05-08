FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 5000

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD src/ /root/

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \
mkdir -p /nobody && \
chown -R nobody:users /nobody && \

# update apt and get node build deps

apt-get update && \
apt-get install -y wget && \
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list && \
apt-get update && \
apt-get install git-core postgresql-9.4 postgresql-server-dev-9.4  postgresql-contrib-9.4 postgresql-plperl-9.4  nodejs npm nodejs-legacy redis-server memcached build-essential libxml2-dev libpq-dev libexpat1-dev libdb-dev libicu-dev liblocal-lib-perl cpanminus libjson-xs-perl libicu-dev -y && \

# fetch source and compile
cd /opt && \
git clone --recursive git://github.com/metabrainz/musicbrainz-server.git && \
cd musicbrainz-server && \
cp lib/DBDefs.pm.sample lib/DBDefs.pm && \
cp lib/DBDefs.pm.sample /root/DBDefs.pm && \
cpanm --installdeps --notest . && \
npm install && \
cd postgresql-musicbrainz-unaccent && \
make && \
make install && \
cd .. && \
cd postgresql-musicbrainz-collate && \
make && \
make install && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
