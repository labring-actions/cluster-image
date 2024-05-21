#!/usr/bin/env bash
set -e

NAME=${NAME:-"oceanbase-dashboard"}
NAMESPACE=${NAMESPACE:-"oceanbase"}
CHARTS=${CHARTS:-"./charts/oceanbase-dashboard"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
