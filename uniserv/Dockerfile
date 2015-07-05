FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive
# Set correct environment variables
ENV HOME /root
ENV TERM xterm

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# add local files
ADD start.sh /root/start.sh
ADD firstrun.sh /etc/my_init.d/firstrun.sh

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt and get dependencies etc.
add-apt-repository ppa:webupd8team/java && \
apt-get update && \
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
apt-get install oracle-java8-installer oracle-java8-set-default mediainfo dcraw vlc-nox mplayer mencoder openssh-server openssh-client -y && \

# fetch ums
cd /root && \
wget http://sourceforge.net/projects/unimediaserver/files/Official%20Releases/Linux/UMS-5.1.4-Java8.tgz && \
tar -xvzf UMS-5.1.4-Java8.tgz && \
rm UMS-5.1.4-Java8.tgz && \
mkdir /etc/service/ums && \
mv /root/start.sh /etc/service/ums/run && \
chmod +x /etc/service/ums/run && \
chmod +x /etc/my_init.d/firstrun.sh
EXPOSE 5001/tcp 2869/tcp 1900/udp 9001/tcp
