FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Add required files that are local
ADD src/ /root/

# expose ports
EXPOSE 5000 5432

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# fix install scripts executable
RUN chmod +x /root/instal*.sh && \
sleep 1s && \

# first installer script
/root/install.sh && \

# break install to enable lib::local
echo "eval $( perl -Mlocal::lib )" >> ~/.bashrc && . ~/.bashrc && \
sleep 1s && \

# second installer script
/root/install2.sh && \

# fix executables
chmod +x /etc/my_init.d/*
