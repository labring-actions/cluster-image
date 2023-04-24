#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"kubernetes-dashboard"}
NAMESPACE=${NAMESPACE:-"kubernetes-dashboard"}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function disable(){
  if helm -n ${NAMESPACE} status ${NAME} > /dev/null 2>&1; then
    helm -n ${NAMESPACE} uninstall ${NAME} > /dev/null 2>&1
    if [ -f ../manifests/dashboard-adminuser.yaml ]; then
    kubectl delete -f ../manifests/dashboard-adminuser.yaml >/dev/null 2>&1 || true
    fi
    log::info "${NAME} is uninstalled"
  else
    log::info "${NAME} is not exits"
  fi
}
disable
