#!/usr/bin/env bash
set -e

NAME=${NAME:-"tianji"}
NAMESPACE=${NAMESPACE:-"tianji"}
CHARTS=${CHARTS:-"./charts/tianji"}
HELM_OPTS=${HELM_OPTS:-" \
--set service.type=NodePort \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
