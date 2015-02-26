This is a Dockerfile setup for sabnzbd - http://sabnzbd.org/ 

This includes a multithreaded par2

To run:

```
docker run -d --name="sabnzbd" -v /path/to/sabnzbd/conf:/config -v /path/to/downloads:/downloads -v /etc/localtime:/etc/localtime:ro -p 8080:8080 needo/sabnzbd
```
