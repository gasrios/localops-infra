#!/bin/bash

# Use this script if you want to update all services at once.

set -e

echo 'Updating services...'

for SERVICE in $(ls services)
do \
	make -C services/$SERVICE
done

echo 'Services updated.'
