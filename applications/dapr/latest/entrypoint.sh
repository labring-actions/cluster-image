#!/usr/bin/env bash
set -e

NAME=${NAME:-"dapr"}
NAMESPACE=${NAMESPACE:-"dapr-system"}
CHART=${CHARTS:-"./charts/dapr"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHART} -n ${NAMESPACE} --create-namespace ${HELM_OPTS} --wait
