FROM phusion/baseimage:0.9.16 

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm

# export ports
EXPOSE 8085

# Gamezserver Configuration
VOLUME /config

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# add local files
ADD /src/ /root/

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \ 
usermod -g 100 nobody && \ 

# fix startup files
mv /root/gamezserver.sh /etc/my_init.d/gamezserver.sh && \
chmod +x /etc/my_init.d/*.sh && \

# Install Dependencies
apt-get update -qq && \
apt-get install \
python \
git-core -y && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
 


