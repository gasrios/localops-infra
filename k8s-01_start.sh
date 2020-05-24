#!/usr/bin/env bash

# You need to source this script, so PREVIOUS_CONTEXT will be visible by k8s-03_stop.sh:
#
# . ./k8s-01_start.sh

echo 'Starting localops (infra)...'

if [ -z ${KUBECONFIG+x} ]
then \
	echo "ERROR: KUBECONFIG is not set."
	exit -1
fi

echo "KUBECONFIG='$KUBECONFIG'."

if [ -z ${CONTEXT+x} ]
then \
	echo "ERROR: CONTEXT is not set."
	exit -1
fi

echo "Using CONTEXT '$CONTEXT'."

if [ -z ${PREVIOUS_CONTEXT+x} ]
then \
	export PREVIOUS_CONTEXT=$(kubectl config current-context)
else \
	echo "PREVIOUS_CONTEXT is already set to $PREVIOUS_CONTEXT, will not overwrite it."
fi

kubectl config use-context $CONTEXT

./k8s-02_update.sh

echo 'localops (infra) started.'
