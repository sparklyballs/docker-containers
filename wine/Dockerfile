FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add local files
ADD src/ /root/

# set workdir 
WORKDIR /

# Expose ports 
EXPOSE 6080 5900 3389

# set startup file
RUN mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \

# update apt and install dependencies
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \
apt-add-repository ppa:ubuntu-mate-dev/ppa && \
apt-add-repository ppa:ubuntu-mate-dev/trusty-mate && \
apt-get update -qq && \
apt-get install \
--no-install-recommends \
xrdp \
wget \
openjdk-7-jre \
supervisor \
sudo \
nano \
x11vnc \
xvfb \
mate-desktop-environment-core -qy && \

# create ubuntu user
useradd --create-home --shell /bin/bash --user-group --groups adm,sudo ubuntu && \
echo "ubuntu:PASSWD" | chpasswd && \

# set user ubuntu to same uid and guid as nobody:users in unraid
usermod -u 99 ubuntu && \
usermod -g 100 ubuntu && \

# swap in modified xrdp.ini
mv /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.original && \
mv /root/xrdp.ini /etc/xrdp/xrdp.ini && \
chown root:root /etc/xrdp/xrdp.ini && \

# update apt for wine installation
dpkg --add-architecture i386 && \
echo "APT::Architectures { "amd64"; "i386"; };" >> /etc/apt/apt.conf && \
apt-get update -qq && \

# install wine
apt-get  \
install \
wine1.6 -qy && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
