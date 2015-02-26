# set base os
FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive
# Set correct environment variables
ENV HOME /root
ENV TERM xterm
CMD ["/sbin/my_init"]

# add local files
RUN mkdir -p /root/conf
ADD amule-sparklyballs_0.0.1_amd64.deb /root/amule.deb
ADD amule.sh /root/amule.sh
ADD amule.conf /root/conf/amule.conf
ADD remote.conf /root/conf/remote.conf
ADD nodes.dat /root/conf/nodes.dat
ADD supervisord.conf /root/supervisord.conf
# set nobody to UID 99
RUN \
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# update apt and install gdebi-core

apt-get update && \
apt-get install -y git-core gdebi-core supervisor && \

# install amule and cleanup
cd /root/ && \
mkdir -p /opt/amule && \
gdebi -n amule.deb && \
rm -rf amule.deb && \
git clone https://github.com/MatteoRagni/AmuleWebUI-Reloaded /opt/amule/amule/bin/share/amule/webserver/AmuleWebUI-Reloaded && \
chown -R nobody:users /opt/amule && \
apt-get purge --remove -y git-core gdebi-core && \
apt-get clean autoclean && \
apt-get autoremove -y && \
rm -rf /var/lib/{apt,dpkg,cache,log}/ && \

# set startup files and make executable
chmod +x /root/amule.sh && \
mv /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# set volumes for completed downloads and config file(s)
VOLUME /config /downloads
# set port(s)
EXPOSE 4711/tcp 4712/tcp 4672/udp 4665/udp 4662/tcp 4661/tcp
ENTRYPOINT ["/root/amule.sh"]

