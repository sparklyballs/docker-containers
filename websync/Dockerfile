FROM linuxserver/baseimage

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

ENV APTLIST="build-essential git nodejs python sshpass wget"

# install packages
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash - && \
apt-get install $APTLIST -qy && \
npm install -g bower && \
npm install -g gulp && \
git clone https://github.com/furier/websync.git /app/websync && \

# give user abc a home folder
usermod -d /app abc && \

# complete install of websync (use setuser, cannot be run as root)
chown -R abc:abc /app  && \
cd /app/websync && \
/sbin/setuser abc npm install && \
/sbin/setuser abc bower install && \
/sbin/setuser abc gulp dist || true && \
rm -rf /app/websync/dist && \
/sbin/setuser abc gulp dist && \

# clean up 
rm -rf rm -rf /app/.*[a-z] && \
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# adding custom files
ADD services/ /etc/service/
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh && \

# configure websync
mv /app/websync/dist/wsdata.json /defaults/wsdata.json

# volumes and ports
VOLUME /config
EXPOSE 3000
