#!/usr/bin/env bash
set -e

NAME=${NAME:-"apisix"}
NAMESPACE=${NAMESPACE:-"apisix"}
CHART=${CHARTS:-"./charts/apisix"}
HELM_OPTS=${HELM_OPTS:-" \
--set dashboard.username=admin \
--set dashboard.password=admin \
"}

helm upgrade -i ${NAME} ${CHART} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
