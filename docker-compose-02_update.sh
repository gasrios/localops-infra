#!/bin/bash

set -e

echo 'Updating services...'

docker-compose down

./docker-compose-01_start.sh

echo 'Services updated.'
