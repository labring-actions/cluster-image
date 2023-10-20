#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"flannel"}
NAMESPACE=${NAMESPACE:-"kube-flannel"}
CHARTS=${CHARTS:-"./charts/flannel"}
HELM_OPTS=${HELM_OPTS:-""}

kubectl create ns ${NAMESPACE} > /dev/null 2>&1 || true
kubectl label --overwrite ns ${NAMESPACE} pod-security.kubernetes.io/enforce=privileged
helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
