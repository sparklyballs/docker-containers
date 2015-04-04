FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive

# Set environment variables
ENV HOME /root
ENV TERM xterm

####################################
#### CHANGE THESE TWO VARIABLES TO #

# ALTER FINAL INSTALLATION FOLDERS #

ENV DBASE_DATA /config/databases
ENV DCM4CHEE_HOME /config/dcm4chee

####################################

ENV DCM_RUN /dcm4chee-mysql/bin/run.sh
ENV DCM4CHEE_TEMP /root/temp-setup/dcm4chee

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# output volumes
VOLUME /IMAGES

# expose ports
EXPOSE 8080 11112

# Add local files
ADD src/ /root/

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# set temporary installation folders
mkdir -p  $DCM4CHEE_TEMP && \
DCM_DIR=$DCM4CHEE_TEMP/dcm4chee-mysql && \
JBOSS_DIR=$DCM4CHEE_TEMP/jboss-GA && \
ARR_DIR=$DCM4CHEE_TEMP/dcm4chee-arr-mysql && \
UNZIP_TEMP=/root/zips && \
mkdir -p $UNZIP_TEMP && \

# install dependencies
apt-get update && \
apt-get install -y wget unzip mysql-server openjdk-6-jdk supervisor && \

# fetch, unzip and install required packages
cd $DCM4CHEE_TEMP && \
wget --directory-prefix=$UNZIP_TEMP  -i /root/get.list && \
unzip -q $UNZIP_TEMP/dcm4chee-2.17.1-mysql.zip && \
unzip -q $UNZIP_TEMP/jboss-4.2.3.GA-jdk6.zip && \
unzip -q $UNZIP_TEMP/dcm4chee-arr-3.0.11-mysql.zip && \
rm -rf $UNZIP_TEMP && \
mv dcm4chee-2.17.1-mysql dcm4chee-mysql && \
mv jboss-4.2.3.GA jboss-GA && \
mv dcm4chee-arr-3.0.11-mysql dcm4chee-arr-mysql && \
$DCM_DIR/bin/install_jboss.sh jboss-GA > /dev/null && \
$DCM_DIR/bin/install_arr.sh dcm4chee-arr-mysql > /dev/null && \

# Patch the JPEGImageEncoder issue for the WADO service
sed -e "s/value=\"com.sun.media.imageioimpl.plugins.jpeg.CLibJPEGImageWriter\"/value=\"com.sun.image.codec.jpeg.JPEGImageEncoder\"/g" < $DCM_DIR/server/default/conf/xmdesc/dcm4chee-wado-xmbean.xml > dcm4chee-wado-xmbean.xml && \
mv dcm4chee-wado-xmbean.xml $DCM_DIR/server/default/conf/xmdesc/dcm4chee-wado-xmbean.xml && \

# Update environment variables
echo "\
JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64\n\
PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"\n\
" > /etc/environment && \


# create databases etc
chmod +x /root/makedb.sh && \
sleep 2s && \
/root/makedb.sh && \

# set start and configuration files
cp /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \
sed -i -e "s#\(log_error.*=\).*#\1 ${DBASE_DATA}/mysql_safe.log#g" /root/my.cnf && \
sed -i -e "s#\(datadir.*=\).*#\1 ${DBASE_DATA}#g" /root/my.cnf && \
cp  /etc/mysql/my.cnf /etc/mysql/my.orig && \
cp /root/my.cnf /etc/mysql/my.cnf && \
cp /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \

# make directory for mysql pid and socket
mkdir -p /var/local/mysql && \
chown -R nobody:users /var/local/mysql && \

# clean up apt etc....
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
