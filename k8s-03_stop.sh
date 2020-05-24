#!/usr/bin/env bash

# You need to source k8s-01_start.sh, so PREVIOUS_CONTEXT will be visible here
#
# . ./ k8s-01_start.sh

echo 'Shutting localops (infra) down...'

for SERVICE in $(ls services)
do \
	make -C services/$SERVICE delete-local
done

if [ -z ${PREVIOUS_CONTEXT+x} ]
then \
	echo "ERROR: PREVIOUS_CONTEXT is not set."
	exit -1
fi

echo "Restoring context '$PREVIOUS_CONTEXT'."
kubectl config use-context $PREVIOUS_CONTEXT

echo 'localops (infra) is down.'
