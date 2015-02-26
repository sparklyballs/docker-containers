# set base os
FROM debian:wheezy
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root
ENV TERM xterm
# Add in required files from local
ADD src/kodi-headless-debian_0.0.1_amd64.deb /root/kodi-headless-debian_0.0.1_amd64.deb

# Configure user nobody to match unRAID's settings
RUN \
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# Install KODI build dependencies
apt-get update && \
apt-get install -y wget gdebi-core build-essential cmake supervisor && \
wget http://pkgs.fedoraproject.org/lookaside/pkgs/taglib/taglib-1.8.tar.gz/dcb8bd1b756f2843e18b1fdf3aaeee15/taglib-1.8.tar.gz && \
tar xzf taglib-1.8.tar.gz && \
cd taglib-1.8 && \
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_RELEASE_TYPE=Release . && \
make && \
make install && \
cd /root && \
gdebi -n kodi-headless-debian_0.0.1_amd64.deb && \
apt-get purge --remove -y wget gdebi-core build-essential cmake && \
apt-get autoremove -y && \
echo "[supervisord]" >> /etc/supervisor/conf.d/supervisord.conf && \
echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf && \
echo "[program:kodi-server]" >> /etc/supervisor/conf.d/supervisord.conf && \
echo "command=/opt/kodi-server/lib/kodi/kodi.bin --nolirc --headless -p" >> /etc/supervisor/conf.d/supervisord.conf && \
rm -rf /root/kodi-headless-debian_0.0.1_amd64.deb
EXPOSE 9777/udp 8080/tcp
ENTRYPOINT ["/usr/bin/supervisord"]
