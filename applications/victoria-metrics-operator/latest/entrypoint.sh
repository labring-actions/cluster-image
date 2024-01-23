#!/usr/bin/env bash
set -e

NAME=${NAME:-"victoria-metrics-operator"}
NAMESPACE=${NAMESPACE:-"vm"}
CHARTS=${CHARTS:-"./charts/victoria-metrics-operator"}
HELM_OPTS=${HELM_OPTS:-" \
--set operator.disable_prometheus_converter=true \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS} --wait
kubectl -n ${NAMESPACE} apply -f manifests/examples/vmcluster.yaml
