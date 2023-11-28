#!/usr/bin/env bash
set -e

NAME=${NAME:-"apisix"}
NAMESPACE=${NAMESPACE:-"ingress-apisix"}
CHARTS=${CHARTS:-"./charts/apisix"}
HELM_OPTS=${HELM_OPTS:-" \
--set gateway.type=NodePort \
--set ingress-controller.enabled=true \
--set ingress-controller.config.apisix.serviceNamespace=ingress-apisix \
--set ingress-controller.config.apisix.adminAPIVersion=v3 \
--set dashboard.enabled=true \
--set dashboard.service.type=NodePort \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
