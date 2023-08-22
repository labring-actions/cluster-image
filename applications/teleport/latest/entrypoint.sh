#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"teleport-cluster"}
NAMESPACE=${NAMESPACE:-"teleport-cluster"}
HELM_OPTS=${HELM_OPTS:-" \
--set clusterName=teleport.example.com \
--set proxyListenerMode=multiplex \
"}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  helm upgrade -i ${NAME} ./charts/${NAME} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

install
