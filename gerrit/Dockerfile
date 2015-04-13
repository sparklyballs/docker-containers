FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm GERRIT_HOME="/opt/gerrit" GERRIT_ROOT="/opt/gerrit" GERRIT_TMP="/root/gerrit-tmp" GERRIT_WAR="/root/gerrit-tmp/gerrit.war"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add local files
ADD src/ /root/

# Expose port(s)
EXPOSE 8080 29418

# install dependencies etc, set supervisor file and get gerrit.
RUN apt-get update && \
apt-get install -y sudo vim-tiny git supervisor openjdk-7-jre-headless wget && \
mv /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
mkdir -p $GERRIT_TMP && \
cd $GERRIT_TMP && \
wget --no-check-certificate https://gerrit-releases.storage.googleapis.com/gerrit-2.10.2.war && \
mv gerrit-2.10.2.war gerrit.war && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

