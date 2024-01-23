#!/usr/bin/env bash
set -e

NAME=${NAME:-"vmsingle"}
NAMESPACE=${NAMESPACE:-"vmsingle"}
CHARTS=${CHARTS:-"./charts/victoria-metrics-single"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
