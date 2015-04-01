elk
===
Docker Image of ELK stack specific to pfSense

This is an adaptation of Elijah Paul's post Monitoring pfSense (2.1) logs using ELK (ElasticSearch, Logstash, Kibana) 
http://elijahpaul.co.uk/monitoring-pfsense-2-1-logs-using-elk-logstash-kibana-elasticsearch/

Dockerfile was modified from cyberabis' docker-elkauto:
https://registry.hub.docker.com/u/cyberabis/docker-elkauto/

Prerequisites:

Docker / www.docker.com

4 Steps to ELK stack for pfSense

1.  Edit conf/logstash.conf and change the pfSense IP to the IP address of your pfSense firewall, and set the timezone to the appropriate setting.

2.  Build the Docker image (From within the northshorenetworks/elk directory where the Dockerfile lives)
	sudo docker build -t northshorenetworks/elk .
	
3.  Run the Docker Image (Modify names/port mappings to suit your needs)
    sudo docker run -d -v <path to northshore/elk>/conf:/conf --name="northshore-elk" -p 80:80 -p 5140:5140/udp -p 5140:5140 -p 9200:9200 northshorenetworks/elk /elk_start.sh
	
4a. (Standard UDP logging) Point pfSense logs to elk server
	Status > System Logs > Settings(tab):
		Enable Remote logging, and set the Server1 IP to be the ip of the docker host:5140 and make sure you are sending Firewall Events.

4b.	(Syslog-ng TCP logging) 	
	
	Install syslog-ng package
	
	Services > syslog-ng:
		1.	Under General Settings tab, enable the service and set the interface to loopback, keep everything else default.
		2.  Under Advance tab:
			a.	Add a destination object named "elk_dest" with the following parameters: { tcp("<dockerserverip>" port(5140));}; 
			b.	Add a log object named "elk_log" with the following parameters: { source(_DEFAULT); destination(elk_dest); };
		3.  Save the config and verify you have logs showing up in the syslog-ng log viewer.
	Point pfSense logs to syslog-ng listener
	Status > System Logs > Settings(tab):
		Enable Remote logging, and set the Server1 IP to be 127.0.0.1:5140 and make sure you are sending Firewall Events.


Browse to http://dockerserver

If you are not seeing any logs show up issue the following command to see if logstash is getting them: sudo docker logs northshore-elk

Report any issues to docker@northshoresoftware.com	
    

