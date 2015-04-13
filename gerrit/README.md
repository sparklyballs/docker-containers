docker-gerrit
=============

Build a Docker container with the gerrit code review system

These are the source files that build the edgester/gerrit Docker image
located at https://registry.hub.docker.com/u/edgester/gerrit/

The current files will build an image that is based on the ubuntu:trusty
image. the images includes:

  * supervisord
  * Gerrit 2.9 using the H2 storage backend

The following ports are exposed in the image:

  * 8080/tcp (http) - Gerrit Web interface
  * 29418/tcp (ssh) - The restricted gerrit ssh daemon


## Building the image

To build the image run the "./build".

To run normally as a daemon, run "./run" or the following command:
`sudo docker run -p 127.0.0.1:8080:8080 -p 127.0.0.1:29418:29418 -d edgester/gerrit `

To use gerrit after starting the container, go to [http://localhost:8080][1] and login with an OpenID service, like Google, Yahoo, or Launchpad. The first person to login is the administrator and may create users and projects.

Source files for this image are at [https://github.com/edgester/docker-gerrit][2]

  [1]: http://localhost:8080
  [2]: https://github.com/edgester/docker-gerrit
