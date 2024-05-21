#!/usr/bin/env bash
set -e

NAME=${NAME:-"oceanbase-cluster"}
NAMESPACE=${NAMESPACE:-"oceanbase"}
CHARTS=${CHARTS:-"./charts/oceanbase-cluster"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
