#!/bin/bash

# Set the locale
locale-gen en_US.UTF-8

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody
usermod -g 100 nobody

# update apt and install dependencies
apt-get update -qq
apt-get install \
python2.7 \
git-core \
supervisor \
python-openssl -y

# fetch nzbmetasearch
cd /root
git clone https://github.com/pillone/usntssearch.git

# set start files
cat <<'EOT' > /etc/my_init.d/001-fix-the-time.sh
#!/bin/bash
if [[ $(cat /etc/timezone) != $TZ ]] ; then
echo "$TZ" > /etc/timezone
exec  dpkg-reconfigure -f noninteractive tzdata
fi
EOT

cat <<'EOT' > /etc/my_init.d/002-copy-the-files.sh
#!/bin/bash
mkdir -p /opt/NZBmegasearch
if [ -f "/opt/NZBmegasearch/mega2.py" ]; then
echo "files appear to be set"
chown -R nobody:users /opt/NZBmegasearch
else
cp -pr /root/usntssearch/NZBmegasearch/* /opt/NZBmegasearch/
chown -R nobody:users /opt/NZBmegasearch
fi
EOT

cat <<'EOT' > /etc/my_init.d/003-start-the-things.sh
#!/bin/bash
/usr/bin/supervisord -c /root/supervisord.conf &
EOT

# supervisor file
cat <<'EOT' > /root/supervisord.conf
[supervisord]
nodaemon=true
[program:megasearch]
user=nobody
directory=/opt/NZBmegasearch
command=python mega2.py
EOT
