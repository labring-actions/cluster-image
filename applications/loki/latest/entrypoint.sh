#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"loki"}
NAMESPACE=${NAMESPACE:-"loki"}
HELM_OPTS=${HELM_OPTS:-" \
--set loki.auth_enabled=false \
--set minio.enabled=true \
--set write.replicas=1 \
--set read.replicas=1 \
--set backend.replicas=1 \
--set loki.commonConfig.replication_factor=1"}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  helm upgrade -i ${NAME} ./charts/loki -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

function uninstall(){
  if helm -n ${NAMESPACE} status ${NAME} &> /dev/null; then
    helm -n ${NAMESPACE} uninstall ${NAME} &> /dev/null
    log::info "${NAME} is uninstalled"
  else
    log::info "${NAME} is not exits"
  fi
}

if [ -z ${uninstall} ]; then
  install
elif [ -n ${uninstall} ]; then
  uninstall
fi
