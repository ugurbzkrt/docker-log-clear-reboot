#!/bin/bash

#Rotate your docker logs files without logrotate.d or reboot your docker service. No downtime! (Use at your own risk.)
#Author:
#Ercan Ermis
#https://ercanermis.com
#https://twitter.com/flightlesstux

#Usage:
#Set your MAX_LOG_SIZE and ready to go...
#The value size should be in bytes. For example:
#10 Gigabytes = 10737418240 Bytes
#20 Gigabytes = 21474836480 Bytes
#30 Gigabytes = 32212254720 Bytes
#40 Gigabytes = 42949672960 Bytes
#50 Gigabytes = 53687091200 Bytes

clear

MAX_LOG_SIZE="10737418240"
SRC="/dev/null"
LOG_PATH=$(find /var/lib/docker/containers/ -type f -name "*-json.log" | xargs ls -laS | sort -n -r)

DEST_LOG=$(find /var/lib/docker/containers/ -type f -name "*-json.log" | xargs ls -la | sort -n -r | head -n 1 | awk '{print $9}')
DEST_LOG_SIZE=$(find /var/lib/docker/containers/ -type f -name "*-json.log" | xargs ls -la | sort -n -r | head -n 1 | awk '{print $5}')

list()
{
    find /var/lib/docker/containers/ -type f -name "*-json.log" | xargs ls -laS | sort -n -r
}

if [ "$DEST_LOG_SIZE" -gt "$MAX_LOG_SIZE" ] 2>/dev/null; then
read -p "
The files fill shown below. Press ENTER to continue...
"

echo $DEST_LOG



list

read -p "

${DEST_LOG} will be delete! Do you want to continue?
"

cp $SRC $DEST_LOG

else
	echo "Total file size ${DEST_LOG_SIZE} bytes. Doesn't necessery at all because it's smaller than ${MAX_LOG_SIZE} bytes." && exit 1
fi
