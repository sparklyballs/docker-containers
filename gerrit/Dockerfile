FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm GERRIT_HOME="/opt/gerrit" GERRIT_TMP="/gerrit-tmp" GERRIT_WAR="/gerrit-tmp/gerrit.war"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add local files
ADD src/ /root/

# Expose port(s)
EXPOSE 8080 29418

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# fix startup files
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \

# install dependencies etc, set supervisor file and get gerrit.
apt-get update && \
apt-get install -y sudo vim-tiny git openjdk-7-jre-headless wget supervisor && \
mkdir -p $GERRIT_TMP && \
cd /tmp && \
wget --no-check-certificate https://gerrit-releases.storage.googleapis.com/gerrit-2.10.2.war && \
mv gerrit-2.10.2.war $GERRIT_WAR && \
chown -R nobody:users $GERRIT_TMP && \
mv /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \


# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

