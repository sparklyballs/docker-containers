FROM phusion/baseimage:0.9.16

ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root
ENV TERM xterm
# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add local files
ADD sabnzbd.sh /root/sabnzbd.sh

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

add-apt-repository ppa:jcfp/ppa && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" && \
add-apt-repository ppa:jon-severinsson/ffmpeg && \
apt-get update -q && \
apt-get install -qy unrar par2 sabnzbdplus wget ffmpeg sabnzbdplus-theme-mobile curl && \

# Install multithreaded par2
apt-get remove --purge -y par2 && \
wget -P /tmp http://www.chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20100203-lin64.tar.gz && \
tar -C /usr/local/bin -xvf /tmp/par2cmdline-0.4-tbb-20100203-lin64.tar.gz --strip-components 1 && \



# Download folders
mkdir -p /mnt/Downloads /mnt/XBMC-Media /mnt/Incomplete && \



# Add sabnzbd to runit
mkdir /etc/service/sabnzbd && \
mv /root/sabnzbd.sh /etc/service/sabnzbd/run && \
chmod +x /etc/service/sabnzbd/run

EXPOSE 8080
EXPOSE 9090

# Path to a directory that only contains the sabnzbd.conf
VOLUME /config
