#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"neuvector"}
NAMESPACE=${NAMESPACE:-"neuvector"}

function enable(){
  helm upgrade -i ${NAME} ../charts/core -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}
enable
