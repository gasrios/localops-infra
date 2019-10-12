#!/usr/bin/env bash

set -euxo pipefail

echo 'Starting localops (infra)...'

for SERVICE in $(ls services)
do \
	make -C services/$SERVICE clean build
done

docker-compose up --build &

sleep 60

echo 'localops (infra) started.'
