#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"openebs-nfs"}
NAMESPACE=${NAMESPACE:-"openebs"}
HELM_OPTS=${HELM_OPTS:-""}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  helm upgrade -i ${NAME} ./charts/nfs-provisioner -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

install
