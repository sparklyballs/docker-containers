#!/bin/bash

# Set the locale
locale-gen en_US.UTF-8

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody
usermod -g 100 nobody

# update apt and install dependencies
apt-get update -qq
apt-get install \
--no-install-recommends \
git-core \
nginx \
php5-fpm \
php5-gd \
libgd2-xpm-dev \
php5-imagick \
imagemagick \
supervisor -y

# fetch photoshow from git and configure it
git clone https://github.com/thibaud-rohmer/PhotoShow.git /var/www/PhotoShow
sed -i -e 's/$config->photos_dir.\+/$config->photos_dir = "\/Pictures";/' /var/www/PhotoShow/config.php
sed -i -e 's/$config->ps_generated.\+/$config->ps_generated = "\/Thumbs";/' /var/www/PhotoShow/config.php
chown -R www-data:www-data /Thumbs

# set supervisor and config files
echo "daemon off;" >> /etc/nginx/nginx.conf
sed -i -e 's/^.\+daemonize.\+$/daemonize = no/' /etc/php5/fpm/php-fpm.conf

cat <<'EOT' > /root/photoshow.conf
[supervisord]
nodaemon=true

[program:httpd]
command=/usr/sbin/nginx
stdout_logfile=/var/log/supervisor/%(program_name)s.stdout
stderr_logfile=/var/log/supervisor/%(program_name)s.stderr
stopsignal=6
autorestart=true

[program:phpfpm]
command=/usr/sbin/php5-fpm
stdout_logfile=/var/log/supervisor/%(program_name)s.stdout
stderr_logfile=/var/log/supervisor/%(program_name)s.stderr
stopsignal=6
autorestart=true
EOT

cat <<'EOT' > /etc/php5/fpm/pool.d/photoshow.conf
[www]
php_value[upload_max_filesize] = 10M
php_value[post_max_size] = 10M
php_value[memory_limit] = 64M
php_value[max_execution_time] = 15
EOT

cat <<'EOT' > /etc/nginx/sites-available/photoshow
upstream php5-fpm-sock {
    server unix:/var/run/php5-fpm.sock;
}

server {
  listen   80;

  error_log /var/log/nginx/photoshow.log info;

  location / {
    alias /var/www/PhotoShow/;
    index index.php;
    client_max_body_size 0;

	  location ~* \.php$ {
		#try_files $uri =404;
		allow all;
		include fastcgi_params;
		fastcgi_pass php5-fpm-sock;
		fastcgi_param SCRIPT_FILENAME /var/www/PhotoShow/$fastcgi_script_name;
		fastcgi_param QUERY_STRING $query_string;
		fastcgi_intercept_errors off;
		client_max_body_size 0;
	  }
  }
}
EOT

rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/photoshow /etc/nginx/sites-enabled/photoshow

# fix up startup files

cat <<'EOT' > /etc/my_init.d/001-fix-the-time.sh
#!/bin/bash
if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
 exec  dpkg-reconfigure -f noninteractive tzdata
fi
sed -i -e 's/^#//' /var/www/PhotoShow/config.php
sed -i -e "s@\$config->timezone.*@\$config->timezone = \"${TZ}\"@g" /var/www/PhotoShow/config.php
EOT

cat <<'EOT' > /etc/my_init.d/002-start-stuff.sh
#!/bin/bash
/usr/bin/supervisord -c /root/photoshow.conf &
EOT
