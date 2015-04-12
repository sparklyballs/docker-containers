# Docker Sonarr (previously NzbDrone)

REBUILT FROM THE OFFICIAL SONARR IMAGE, FOR UNRAID
### Ports
- **TCP 8989** - Web Interface

### Volumes
- **/volumes/config** - Sonarr configuration data
- **/volumes/completed** - Completed downloads from download client
- **/volumes/media** - Sonarr media folder

Docker runs as uid 100 (nobody on unraid)

## Running

The quickest way to get it running without integrating with a download client or media server (plex)
```
sudo docker run --restart always --name sonarr -p 8989:8989 -v /path/to/your/media/folder/:/volumes/media -v /path/to/your/completed/downloads:/volumes/completed tuxeh/sonarr
```

You can link to the download client's volumes and plex using something similar:
```
sudo docker run --restart always --name sonarr --volumes-from plex --link plex:plex --volumes-from deluge --link deluge:deluge -p 8989:8989 tuxeh/sonarr
```

