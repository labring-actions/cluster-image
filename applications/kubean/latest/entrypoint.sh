#!/usr/bin/env bash
set -e

NAME=${NAME:-"kubean"}
NAMESPACE=${NAMESPACE:-"kubean-system"}
CHARTS=${CHARTS:-"./charts/kubean"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
