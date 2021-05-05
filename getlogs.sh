#!/bin/bash
#
# Author: Ezra S. Brooker
# Year: 2021
# Dept of Scientific Computing, Florida State University
#
# runtime script to access Docker and Apache server logs while the 
# Docker container is running, this allows the debugging of issues
# particularly for the ViewVC/Apache setup
#

containerName=$1 # Save input variable holding Docker Container name

if [ -z "$containerName" ]; then

	echo -e "\nPlease give a Docker Container name as command line input\n"

else

	if [ "$(docker ps -a | grep $containerName)" ]; then

		currentDate=$(date +%Y-%m-%d-%H_%M_%S)
		echo -e "\nDate appended to end of name of logfiles: $currentDate\n"

		echo -e "[SUCCESS] <$containerName> Docker Container Logs accessed at $currentDate" >> dockerLogAccess.log

		if [ ! -d "./$containerName-logs" ]; then
			mkdir "./$containerName-logs"
		fi

		echo -e "Fetching Docker Logs from Docker Container: $containerName"
		if [ ! -d "./$containerName-logs/dockerLogs" ]; then
			mkdir "./$containerName-logs/dockerLogs"
		fi

		docker logs $containerName >& $containerName-logs/dockerLogs/docker.log-$currentDate

		echo -e "Fetching Apache Logs from Docker Container: $containerName\n"
		if [ ! -d "./$containerName-logs/apacheLogs" ]; then
			mkdir "./$containerName-logs/apacheLogs"
		fi
		docker cp $containerName:/etc/httpd/logs/error_log       ./$containerName-logs/apacheLogs/error.log-$currentDate
		docker cp $containerName:/etc/httpd/logs/access_log      ./$containerName-logs/apacheLogs/access.log-$currentDate
		docker cp $containerName:/etc/httpd/logs/ssl_error_log   ./$containerName-logs/apacheLogs/ssl_error.log-$currentDate
		docker cp $containerName:/etc/httpd/logs/ssl_access_log  ./$containerName-logs/apacheLogs/ssl_access.log-$currentDate
		docker cp $containerName:/etc/httpd/logs/ssl_request_log ./$containerName-logs/apacheLogs/ssl_request.log-$currentDate

	else
		echo -e "[ERROR] <$containerName> not running; failed to access Docker Container Logs at $currentDate" >> dockerLogAccess.log

	fi
fi
echo -e "\n"

