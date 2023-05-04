#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME="ceph-csi-rbd"
NAMESPACE="ceph-csi-rbd"
HELM_OPTS="${HELM_OPTS:-}"

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install() {
  helm upgrade -i ${NAME} ./charts/ceph-csi-rbd -n ${NAMESPACE} --create-namespace \
  -f ./charts/ceph-csi-rbd.values.yaml ${HELM_OPTS}
}

function uninstall() {
  if helm -n ${NAMESPACE} status ${NAME} > /dev/null 2>&1; then
    helm -n ${NAMESPACE} uninstall ${NAME} --wait
    log::info "${NAME} is uninstalled"
  else
    log::info "${NAME} not found in cluster"
  fi
}

if [ -z ${uninstall} ]; then
  install
elif [ -n ${uninstall} ]; then
  uninstall
fi
