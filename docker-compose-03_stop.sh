#!/usr/bin/env bash

echo 'Shutting localops (infra) down...'

docker-compose down

for SERVICE in $(ls services)
do \
	for IMAGE_ID in $(docker image ls | grep "$SERVICE" | sed 's/^\S\+\s\+\S\+\s\+\(\S\+\).*/\1/')
	do \
		docker image rm -f $IMAGE_ID
	done
done

echo 'localops (infra) is down.'
