#!/usr/bin/env bash
set -e

NAME=${NAME:-"apisix"}
NAMESPACE=${NAMESPACE:-"apisix"}
CHARTS=${CHARTS:-"./charts/apisix"}
HELM_OPTS=${HELM_OPTS:-" \
--set dashboard.username=admin \
--set dashboard.password=admin \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
