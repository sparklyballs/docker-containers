#!/bin/bash

mkdir -p /var/www/pydio
mkdir -p /config/keys

# Fix the timezone
if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
  sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php5/apache2/php.ini
  sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php5/cli/php.ini
fi

if [[ -f /config/keys/server.key && -f /config/keys/server.pem ]]; then
  echo "Found pre-existing certificate, using it."
  cp -f /config/keys/server.* /opt/
else
  if [[ -z $SUBJECT ]]; then 
    SUBJECT="/C=US/ST=CA/L=Carlsbad/O=Lime Technology/OU=unRAID Server/CN=yourhome.com"
  fi
  echo "No pre-existing certificate found, generating a new one with subject:"
  echo $SUBJECT
  openssl req -new -x509 -days 3650 -nodes -out /opt/server.pem -keyout /opt/server.key \
          -subj "$SUBJECT"
  ls /opt/
  cp -f /opt/server.*  /config/keys/
 fi



if [ -f "/var/www/pydio/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2
else
cd /var/www
cp -r /root/pydio/* /var/www/pydio/
chown -R www-data:www-data /var/www/pydio
fi

if [ -f "/config/ssmtp.conf" ]; then
rm /etc/ssmtp/ssmtp.conf
cp /config/ssmtp.conf /etc/ssmtp/ssmtp.conf
else
cp /root/ssmtp.conf /config/ssmtp.conf
chown -R nobody:users /config
echo "EDIT SSMTP CONFIG AND RESTART CONTAINER"
fi

find /var/www/pydio -not -path "/var/www/pydio/data" -exec chown www-data:www-data {} \;

