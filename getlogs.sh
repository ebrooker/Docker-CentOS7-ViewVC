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

contName=$1 # Save input variable holding Docker Container name

if [ -z "$contName" ]; then

	echo -e "\nPlease give a Docker Container name as command line input\n"

else

	if [ "$(docker ps -a | grep Hydrus_Server)" ]; then

		currentDate=$(date +%Y-%m-%d-%H_%M_%S)
		echo -e "\nDate appended to end of name of logfiles: $currentDate\n"

		echo -e "[SUCCESS] <$contName> Docker Container Logs accessed at $currentDate" >> dockerLogAccess.log

		if [ ! -d "./$contName-logs" ]; then
			mkdir "./$contName-logs"
		fi

		echo -e "Fetching Docker Logs from Docker Container: $contName"
		if [ ! -d "./$contName-logs/DockerLogs" ]; then
			mkdir "./$contName-logs/DockerLogs"
		fi

		docker logs $contName >& $contName-logs/DockerLogs/docker.log-$currentDate

		echo -e "Fetching Apache Logs from Docker Container: $contName\n"
		if [ ! -d "./$contName-logs/ApacheLogs" ]; then
			mkdir "./$contName-logs/ApacheLogs"
		fi
		docker cp $contName:/etc/httpd/logs/error_log       ./$contName-logs/ApacheLogs/error.log-$currentDate
		docker cp $contName:/etc/httpd/logs/access_log      ./$contName-logs/ApacheLogs/access.log-$currentDate
		docker cp $contName:/etc/httpd/logs/ssl_error_log   ./$contName-logs/ApacheLogs/ssl_error.log-$currentDate
		docker cp $contName:/etc/httpd/logs/ssl_access_log  ./$contName-logs/ApacheLogs/ssl_access.log-$currentDate
		docker cp $contName:/etc/httpd/logs/ssl_request_log ./$contName-logs/ApacheLogs/ssl_request.log-$currentDate

	else
		echo -e "[ERROR] <$contName> not running; failed to access Docker Container Logs at $currentDate" >> dockerLogAccess.log

	fi
fi
echo -e "\n"

