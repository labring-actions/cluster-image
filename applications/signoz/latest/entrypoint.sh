#!/usr/bin/env bash
set -e

NAME=${NAME:-"signoz"}
NAMESPACE=${NAMESPACE:-"platform"}
CHARTS=${CHARTS:-"./charts/signoz"}
HELM_OPTS=${HELM_OPTS:-" \
--set frontend.service.type=NodePort \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
