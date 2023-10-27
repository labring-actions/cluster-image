#!/usr/bin/env bash
set -e

NAME=${NAME:-"kubernetes-dashboard"}
NAMESPACE=${NAMESPACE:-"kubernetes-dashboard"}
CHARTS=${CHARTS:-"./charts/kubernetes-dashboard"}
HELM_OPTS=${HELM_OPTS:-" \
--set service.type=NodePort \
--set metricsScraper.enabled=true \
--set extraArgs[0]=--token-ttl=0 \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}

if [ -f ./manifests/dashboard-adminuser.yaml ]; then
    kubectl apply -f ./manifests/dashboard-adminuser.yaml
fi
