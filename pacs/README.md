docker-dcm4chee
===============

This project builds a docker image for the DCM4CHEE medical image manager/archive. The Docker image includes DCM4CHEE running on a JBoss webapp server, backed by a MySQL database.

Empty databases and the dcm4chee installation are generated at build time in temp locations that are copied to /config at first run. This allows data to be persistent and to test with dummy data (delete the locally stored content and restart the container to get a virgin installation) 
It should also be noted that it is modded for unraid.

## Building and running the 'dcm4chee' image

The 'dcm4chee' image is built as follows:

    docker build --rm=true -t sparklyballs/pacs .

Once built the 'dcm4chee' image is run as follows:

    docker run -d -v <YOUR LOCAL STORAGE>:/config -p 8080:8080 -p 11112:11112 --name pacs sparklyballs/pacs

Note that two ports must be mapped. Port 8080 is used by the DCM4CHEE web UI, while port 11112 is the DICOM port through which PACS workstations can perform DICOM network actions such as searching the archive, and downloading and uploading medical images.

## Managing the server

Once a dcm4chee container is running its web UI available at [http://localhost:8080/dcm4chee-web3](http://localhost:8080/dcm4chee-web3).

The default Administrator login is 'admin', password 'admin'.  The admin password can be changed in the web UI, and new users with reduced permissions can be added.

The server's default Application Entity (AE) title is 'DCM4CHEE'. If you need to change the AE title (for example beause you already have a server with the same name) it is done through the JMX management interface at [http://localhost:8080/jmx-console](http://localhost:8080/jmx-console). Follow the link `service=AE` to the configuration page for the AE service (under the 'dcm4chee.archive' heading).  Invoke the operation `updateAETitle()`, specifying the old AE title 'DCM4CHEE' and your AE title as parameters.

DICOM communications between two parties, such as a client image viewer app and a DCM4CHEE server, require the AE info of each party to be configured on the other party to allow them to talk to each other.  So on your client app you must at least configure theserver's AE title, host name (or IP address), and port number, and on the server you must at least configure the client's AE title, host, and port.  The DCM4CHEE web UI provides a 'DICOM Echo' facility to test the server to client connection, and your client app should also provide a similar facility to send a DICOM Echo to the server.  Once you have finished configuring AE info, and you have verified that each side can successfully send a DICOM Echo to the other side, you are ready to store DICOM images to your DCM4CHEE server.


Initially based on:- 
https://github.com/dpatriarche/docker-dcm4chee
