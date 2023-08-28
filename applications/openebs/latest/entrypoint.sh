#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"openebs"}
NAMESPACE=${NAMESPACE:-"openebs"}
UNINSTALL=${UNINSTALL:-"false"}
HELM_OPTS=${HELM_OPTS:-" \
--set ndm.enabled=false \
--set ndmOperator.enabled=false \
--set localprovisioner.deviceClass.enabled=false \
--set localprovisioner.hostpathClass.isDefaultClass=true \
"}

function log_info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function log_error() {
  printf "%s \033[31merror \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log_error "$1 is required, exiting"
    exit 1
  fi
}

function install(){
  helm upgrade -i ${NAME} ./charts/${NAME} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

function uninstall(){
  if helm -n ${NAMESPACE} status ${NAME} > /dev/null 2>&1; then
    helm -n ${NAMESPACE} uninstall ${NAME} > /dev/null 2>&1
    log_info "${NAME} is uninstalled"
  else
    log_info "${NAME} is not exits"
  fi
}

function main(){
  check_command helm
  if [ "$uninstall" = "true" ]; then
    uninstall
  else
    install
  fi
}

main $@
