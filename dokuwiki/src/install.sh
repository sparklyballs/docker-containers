#!/bin/bash

# Set the locale
locale-gen en_US.UTF-8

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody
usermod -g 100 nobody

# update apt and install dependencies
apt-get update -qq
apt-get install \
wget \
apache2 \
php5 -y

# configure apache mods and php
a2enmod php5
a2enmod rewrite
sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# fetch dokuwiki from source with wget
cd /root
mkdir dokuwiki
cd dokuwiki
wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
tar xvf dokuwiki-stable.tgz --strip 1
rm dokuwiki-stable.tgz



# apache virtual host file for dokuwiki

cat <<'EOT' > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
      DocumentRoot /var/www/dokuwiki
        <Directory />
                Options FollowSymLinks
                AllowOverride All
       </Directory>
        <Directory /var/www/dokuwiki>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>

       <Directory /var/www/dokuwiki/data>
                Order allow,deny
                deny from all
      </Directory>
      <Directory /var/www/dokuwiki/conf>
                 Order allow,deny
                 deny from all
      </Directory>
      <Directory /var/www/dokuwiki/bin>
                 Order allow,deny
                 deny from all
      </Directory>
      <Directory /var/www/dokuwiki/inc>
                 Order allow,deny
                 deny from all
      </Directory>

</VirtualHost>
EOT


# start files

mkdir -p /etc/service/apache
cat <<'EOT' > /etc/service/apache/run
#!/bin/bash
exec /usr/sbin/apache2ctl -D FOREGROUND
EOT

cat <<'EOT' > /etc/my_init.d/001-fix-the-time.sh
#!/bin/bash
if [[ $(cat /etc/timezone) != $TZ ]] ; then
echo "$TZ" > /etc/timezone
exec  dpkg-reconfigure -f noninteractive tzdata
sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php5/apache2/php.ini
sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php5/cli/php.ini
fi
EOT

cat <<'EOT' > /etc/my_init.d/002-copy-files.sh
#!/bin/bash
mkdir -p /var/www/dokuwiki
if [ -f "/var/www/dokuwiki/index.php" ]; then
echo "using existing website"
chown -R www-data:www-data /var/log/apache2 /var/www/dokuwiki
else
echo "copying dokuwiki files"
cp -pr /root/dokuwiki/*  /var/www/dokuwiki/
chown -R www-data:www-data /var/www/dokuwiki
fi
EOT
