#!/usr/bin/env bash

set -euxo pipefail

# You need to source k8s-01_start.sh, so PREVIOUS_CONTEXT will be visible here
#
# . ./ k8s-01_start.sh

echo 'Shutting localops (infra) down...'

for SERVICE in $(ls services)
do \
	for IMAGE_ID in \
		$(docker image ls | grep "$SERVICE" | sed 's/^\S\+\s\+\S\+\s\+\(\S\+\).*/\1/')
	do \
		kubectl delete --ignore-not-found service $SERVICE
		kubectl delete --ignore-not-found deployment $SERVICE
		sleep 5
		docker image rm -f $IMAGE_ID
	done
done

if [ -z ${PREVIOUS_CONTEXT+x} ]
then \
	echo "ERROR: PREVIOUS_CONTEXT is not set."
	exit -1
fi

echo "Restoring context '$PREVIOUS_CONTEXT'."
kubectl config use-context $PREVIOUS_CONTEXT

echo 'localops (infra) is down.'
