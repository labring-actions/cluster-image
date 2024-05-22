#!/usr/bin/env bash
set -e

NAME=${NAME:-"ob-operator"}
NAMESPACE=${NAMESPACE:-"oceanbase-system"}
CHARTS=${CHARTS:-"./charts/ob-operator"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS} --wait
