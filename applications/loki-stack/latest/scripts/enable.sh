#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"loki"}
NAMESPACE=${NAMESPACE:-"loki-stack"}

HELM_OPTS=${HELM_OPTS:-"-f ../charts/loki-stack.values.yaml"}
function enable(){
  helm upgrade -i ${NAME} ../charts/loki-stack -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}
enable
