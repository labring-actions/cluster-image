#!/usr/bin/env bash
set -e

NAME=${NAME:-"pulsar"}
NAMESPACE=${NAMESPACE:-"pulsar"}
CHARTS=${CHARTS:-"./charts/pulsar"}
VALUES_FILE=${VALUES_FILE:-"./manifest/examples/values-one-node.yaml"}
HELM_OPTS=${HELM_OPTS:-" \
-f $VALUES_FILE \
--set components.pulsar_manager=true \
--set pulsar_manager.service.type=NodePort \
--set proxy.service.type=NodePort \
--set kube-prometheus-stack.grafana.service.type=NodePort \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
