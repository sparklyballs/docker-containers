FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TERM xterm

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# add local files
ADD edge.sh /etc/my_init.d/edge.sh
ADD htpcmanager.sh /root/htpcmanager.sh

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /home nobody && \
 chown -R nobody:users /home && \


#Install HTPC Manager

  add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" && \
  add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" && \
  apt-get update -q && \
  apt-get install -qy python git-core python-dev python-pip libjpeg62 libjpeg62-dev libpng12-dev libfreetype6 libfreetype6-dev zlib1g-dev && \
  git clone -b master https://github.com/styxit/HTPC-Manager.git /opt/HTPC-Manager && \
  chown nobody:users /opt/HTPC-Manager  && \
  pip install pillow && \
  pip install psutil && \

# move and change permissions start files
chmod +x /etc/my_init.d/edge.sh && \
mkdir /etc/service/htpcmanager && \
mv /root/htpcmanager.sh /etc/service/htpcmanager/run && \
chmod +x /etc/service/htpcmanager/run

#Expose Ports
EXPOSE 8085

#Expose Config Folder
VOLUME /config
