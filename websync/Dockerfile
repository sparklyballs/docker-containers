FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 3000

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
#ADD src/ /root/

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \
mkdir -p /nobody && \
chown -R nobody:users /nobody && \

# fix up start file
mkdir -p /etc/service/websync && \
mv /root/start.sh /etc/service/websync/run && \
chmod +x /etc/service/websync/run && \

# update apt and get node build deps
apt-get update && \
apt-get install git nodejs npm wget sshpass -y && \
cp /usr/bin/nodejs /usr/bin/node && \
npm install -g bower && \
npm install -g gulp

# set user nobody and home to /nobody
ENV HOME /nobody
USER nobody

# fetch websync files
RUN cd /nobody && \
git clone https://github.com/furier/websync.git && \
cd websync && \
git checkout 27d58e540b3dcdd89d870e4bf1decadfece9ebcb && \ 
npm install && \
bower install && \
gulp dist

# reset user to root for runtime
USER root
 

