FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive
# Set correct environment variables
ENV HOME /root
ENV TERM xterm
# Use baseimage-docker's init system
CMD ["/sbin/my_init"]
# Add local files
ADD firstrun.sh /root/firstrun.sh
ADD comicstreamer.sh /root/comicstreamer.sh

# move startup files and make executable

RUN mkdir -p /etc/my_init.d && \
mv /root/firstrun.sh  /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \
mkdir /etc/service/comicstreamer && \
mv /root/comicstreamer.sh /etc/service/comicstreamer/run && \
chmod +x /etc/service/comicstreamer/run && \

# install apps and dependencies
apt-get update && \
apt-get install python python-dev python-pip build-essential libjpeg8 libjpeg8-dev zlib1g-dev libtiff5-dev libtiff5 libfreetype6 libfreetype6-dev liblcms2-2 liblcms2-dev libwebp5 libwebp-dev libopenjpeg-dev libopenjpeg2 tcl8.6 tcl8.6-dev git-core  -y && \
pip install tornado sqlalchemy watchdog python-dateutil pillow configobj natsort

# expose required port
EXPOSE 32500
VOLUME /root/.ComicStreamer /comics
