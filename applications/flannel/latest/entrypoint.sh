#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"flannel"}
NAMESPACE=${NAMESPACE:-"kube-flannel"}
HELM_OPTS=${HELM_OPTS:-""}

kubectl create ns ${NAMESAPCE} > /dev/null 2>&1 || true
kubectl label --overwrite ns ${NAMESAPCE} pod-security.kubernetes.io/enforce=privileged
helm upgrade -i ${NAME} ./charts/flannel -n ${NAMESAPCE} --create-namespace ${HELM_OPTS}
