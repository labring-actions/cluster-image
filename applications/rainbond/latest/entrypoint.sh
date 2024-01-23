#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"rainbond"}
NAMESPACE=${NAMESPACE:-" rbd-system"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ./chart/rainbond-cluster -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
