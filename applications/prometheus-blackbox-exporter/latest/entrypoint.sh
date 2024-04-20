#!/usr/bin/env bash
set -e

NAME=${NAME:-"prometheus-node-exporter"}
NAMESPACE=${NAMESPACE:-"exporter"}
CHARTS=${CHARTS:-"./charts/prometheus-blackbox-exporter"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
