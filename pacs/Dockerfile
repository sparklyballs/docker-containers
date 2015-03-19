FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive
# Set correct environment variables
ENV HOME /root
ENV TERM xterm
# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# output volumes
VOLUME /DICOM /DATABASE

# expose ports
EXPOSE 8080 11112

# Add local files
ADD src/ /root/

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

# set temporary installation folder
DCM4CHEE_TEMP=/root/temp-setup/dcm4chee && \
mkdir -p  $DCM4CHEE_TEMP && \

# install dependencies
apt-get update && \
apt-get install -y wget unzip mysql-server openjdk-6-jdk && \
apt-get install -y mysqltuner && \

# fetch, unzip and install required packages
cd $DCM4CHEE_TEMP && \
wget --directory-prefix=/root http://sourceforge.net/projects/dcm4che/files/dcm4chee/2.17.1/dcm4chee-2.17.1-mysql.zip && \
unzip -q /root/dcm4chee-2.17.1-mysql.zip && \
DCM_DIR=$DCM4CHEE_TEMP/dcm4chee-2.17.1-mysql && \
wget --directory-prefix=/root http://colocrossing.dl.sourceforge.net/project/jboss/JBoss/JBoss-4.2.3.GA/jboss-4.2.3.GA-jdk6.zip && \
unzip -q /root/jboss-4.2.3.GA-jdk6.zip && \
JBOSS_DIR=$DCM4CHEE_TEMP/jboss-4.2.3.GA && \
wget --directory-prefix=/root http://sourceforge.net/projects/dcm4che/files/dcm4chee-arr/3.0.11/dcm4chee-arr-3.0.11-mysql.zip && \
unzip -q /root/dcm4chee-arr-3.0.11-mysql.zip  && \
ARR_DIR=$DCM4CHEE_TEMP/dcm4chee-arr-3.0.11-mysql && \
rm -rf /root/*.zip && \
$DCM_DIR/bin/install_jboss.sh jboss-4.2.3.GA > /dev/null && \
$DCM_DIR/bin/install_arr.sh dcm4chee-arr-3.0.11-mysql > /dev/null && \

# Patch the JPEGImageEncoder issue for the WADO service
sed -e "s/value=\"com.sun.media.imageioimpl.plugins.jpeg.CLibJPEGImageWriter\"/value=\"com.sun.image.codec.jpeg.JPEGImageEncoder\"/g" < $DCM_DIR/server/default/conf/xmdesc/dcm4chee-wado-xmbean.xml > dcm4chee-wado-xmbean.xml && \
mv dcm4chee-wado-xmbean.xml $DCM_DIR/server/default/conf/xmdesc/dcm4chee-wado-xmbean.xml && \

# Update environment variables
echo "\
JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64\n\
PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"\n\
" > /etc/environment && \

# clean up apt etc....
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \



# set start files etc...
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \

