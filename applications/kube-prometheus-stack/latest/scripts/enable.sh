#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"prometheus"}
NAMESPACE=${NAMESPACE:-"monitoring"}

HELM_OPTS=${HELM_OPTS:-"-f ../charts/kube-prometheus-stack.values.yaml"}
function enable(){
  helm upgrade -i ${NAME} ../charts/kube-prometheus-stack -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}
enable
