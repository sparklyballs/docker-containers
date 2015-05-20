FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set PERL environment variables
ENV PERL_MB_OPT="--install_base /root/perl5" PERL_MM_OPT="INSTALL_BASE=/home/username/perl5" PERL5LIB="/root/perl5/lib/perl5" PATH="/root/perl5/bin:$PATH" PERL_LOCAL_LIB_ROOT="/root/perl5:$PERL_LOCAL_LIB_ROOT"
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
