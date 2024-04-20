#!/usr/bin/env bash
set -e

NAME=${NAME:-"stakater-reloader"}
NAMESPACE=${NAMESPACE:-"reloader"}
CHARTS=${CHARTS:-"./charts/reloader"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
