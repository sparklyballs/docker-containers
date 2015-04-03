# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm
CMD ["/sbin/my_init"]

# add local files
ADD src/ /root/

# set volumes for completed downloads and config file(s)
VOLUME /config /downloads

# expose port(s)
EXPOSE 4711/tcp 4712/tcp 4672/udp 4665/udp 4662/tcp 4661/tcp

# set startup file 
RUN mv /root/amule.sh /etc/my_init.d/amule.sh && \
chmod +x /etc/my_init.d/amule.sh && \

# set nobody to UID 99 GUID 100
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

# set supervisor file
mv /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


