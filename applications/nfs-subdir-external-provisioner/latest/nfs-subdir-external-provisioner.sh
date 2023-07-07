#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"nfs-subdir-external-provisioner"}
NAMESPACE=${NAMESPACE:-"nfs-provisioner"}
HELM_OPTS="${HELM_OPTS:-}"

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  helm upgrade -i ${NAME} charts/${NAME} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

function uninstall() {
  log::info "uninstall nfs-subdir-external-provisioner"
  helm -n ${NAMESPACE} uninstall ${NAME}
}

if [ -z ${uninstall} ]; then
  install
elif [ -n ${uninstall} ]; then
  uninstall
fi
