#!/bin/bash
#
# Author: Ezra S. Brooker
# Year: 2021
# Dept of Scientific Computing, Florida State University
#
# runtime script to build and run a Docker container for 
# ViewVC access through httpd Apache webserver
# Uses the local host as the domain for now
#

# Change these variable names as you see fit
containerName=My_Server
imageName=centos7_httpd_viewvc

# Uncomment below and specify path to existingrepo to mount to container
#repoPath=

# Make sure the container is stopped and removed before any rebuilding occurs
docker stop $containerName
docker rm $containerName
docker build --rm -t $imageName  .


# Uncomment this if mounting existing local repo to container
# docker run -dit --name $containerName \
# -v $repoPath:/svn:ro \
# -p 80:80 $imageName 

# Otherwise, use this docker run line
docker run -dit --name $containerName \
-p 80:80 $imageName 


# Save initial logs
./getlogs.sh $containerName
docker logs $containerName
docker ps
