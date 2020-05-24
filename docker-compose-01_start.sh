#!/usr/bin/env bash

echo 'Starting localops (infra)...'

for SERVICE in $(ls services)
do \
	make -C services/$SERVICE
done

docker-compose up --build &

sleep 60

echo 'localops (infra) started.'
