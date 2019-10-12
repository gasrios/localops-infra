#!/usr/bin/env bash

set -euxo pipefail

echo 'Updating services...'

docker-compose down

./docker-compose-01_start.sh

echo 'Services updated.'
