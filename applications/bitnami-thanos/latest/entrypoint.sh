#!/usr/bin/env bash
set -e

NAME=${NAME:-"thanos"}
NAMESPACE=${NAMESPACE:-"thanos"}
CHARTS=${CHARTS:-"./charts/thanos"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
