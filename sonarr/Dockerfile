FROM debian:wheezy

# Set correct environment variables
ENV HOME="/root" TERM=xterm

# add local files
ADD src/ /root/

# expose ports
EXPOSE 8989 9898

# set volumes
VOLUME /config /downloads /tv

# set entrypoint
ENTRYPOINT ["/usr/bin/supervisord"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# install dependencies
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
echo "deb http://apt.sonarr.tv/ develop main" | tee -a /etc/apt/sources.list && \
apt-get update -q && \
apt-get install -qy nzbdrone mediainfo supervisor && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

# set permissions for folders etc
chown -R nobody:users /opt/NzbDrone && \
mkdir -p /config/sonarr /downloads /tv && \
chown -R nobody:users /downloads /tv /config && \

# Fix supervisor file
mv /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
