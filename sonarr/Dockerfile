FROM debian:wheezy

# expose ports
EXPOSE 8989 9898

# set volumes
VOLUME /volumes/config
VOLUME /volumes/completed
VOLUME /volumes/media

# add local files
ADD develop/ /root/

#set entrypoint
ENTRYPOINT ["/root/start.sh"]

# Fix startup files
RUN chmod 755 /root/sonarr-update.sh && \
chown nobody:users /root/start.sh /root/sonarr-update.sh && \
chmod +x /root/start.sh && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \


echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
echo "deb http://apt.sonarr.tv/ master main" | tee -a /etc/apt/sources.list && \
apt-get update -q && \
apt-get install -qy nzbdrone mediainfo && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

# set permissions for folders etc
chown -R nobody:users /opt/NzbDrone && \
mkdir -p /volumes/config/sonarr /volumes/completed /volumes/media && \
chown -R nobody:users /volumes

# set runtume user and workdir
USER nobody
WORKDIR /opt/NzbDrone
