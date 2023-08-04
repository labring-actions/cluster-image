#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"csi-driver-nfs"}
NAMESPACE=${NAMESPACE:-"csi-driver-nfs"}
HELM_OPTS="${HELM_OPTS:-}"

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  helm upgrade -i ${NAME} ./charts/csi-driver-nfs -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
  if [ -n "$server" ] && [ -n "$share" ]; then
    kubectl apply -f manifests/storageclass-nfs.yaml
  fi
}

install
