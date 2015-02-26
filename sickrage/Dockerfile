FROM phusion/baseimage:0.9.16
MAINTAINER needo <needo@superhero.org>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse"
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse"
RUN apt-get update -q

# Install Dependencies
RUN apt-get install -qy python python-cheetah ca-certificates wget unrar git

# Install SickRage

RUN git clone https://github.com/SiCKRAGETV/SickRage.git /opt/sickrage
RUN chown nobody:users /opt/sickrage

EXPOSE 8081

# SickRage  Configuration
VOLUME /config

# Downloads and TV Directories
RUN mkdir /mnt/XBMC-Media

# Add edge.sh to execute during container startup
RUN mkdir -p /etc/my_init.d
ADD edge.sh /etc/my_init.d/edge.sh
RUN chmod +x /etc/my_init.d/edge.sh

# Add Sickbeard to runit
RUN mkdir /etc/service/sickrage
ADD sickrage.sh /etc/service/sickrage/run
RUN chmod +x /etc/service/sickrage/run
