#!/usr/bin/env bash
set -e

NAME=${NAME:-"argocd"}
NAMESPACE=${NAMESPACE:-"argocd"}
CHART=${CHARTS:-"./charts/argo-cd"}
HELM_OPTS=${HELM_OPTS:-" \
--set server.service.type=NodePort \
"}

cp -f opt/argocd /usr/local/bin/
helm upgrade -i ${NAME} ${CHART} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
