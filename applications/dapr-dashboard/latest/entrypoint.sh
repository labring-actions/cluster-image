#!/usr/bin/env bash
set -e

NAME=${NAME:-"dapr-dashboard"}
NAMESPACE=${NAMESPACE:-"dapr-system"}
CHARTS=${CHARTS:-"./charts/dapr-dashboard"}
HELM_OPTS=${HELM_OPTS:-" \
--set serviceType=NodePort \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
