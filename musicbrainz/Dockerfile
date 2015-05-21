FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Add required files that are local
ADD src/ /root/

# expose ports
EXPOSE 5000 5432

# volumes
VOLUME /data /import /config

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# fix install scripts executable
RUN chmod +x /root/install.sh && \
sleep 1s && \

# installer script
/root/install.sh && \

# fix executables
chmod +x /etc/my_init.d/*
