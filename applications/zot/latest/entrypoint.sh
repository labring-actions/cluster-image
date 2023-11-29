#!/usr/bin/env bash
set -e

NAME=${NAME:-"zot"}
NAMESPACE=${NAMESPACE:-"zot"}
CHARTS=${CHARTS:-"./charts/zot"}
HELM_OPTS=${HELM_OPTS:-" \
--set persistence=true \
--set pvc.create=true \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
