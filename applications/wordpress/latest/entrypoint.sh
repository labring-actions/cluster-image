#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"wordpress"}
NAMESPACE=${NAMESPACE:-"wordpress"}
HELM_OPTS="${HELM_OPTS:-}"

function install(){
  helm upgrade -i ${NAME} ./charts/wordpress -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

install
