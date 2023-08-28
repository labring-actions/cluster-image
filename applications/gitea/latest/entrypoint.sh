#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"gitea"}
NAMESPACE=${NAMESPACE:-"gitea"}
UNINSTALL=${UNINSTALL:-"false"}
HELM_OPTS=${HELM_OPTS:-" \
--set gitea.admin.password=gitea_admin \
--set ingress.enabled=true \
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
    log_info "You should manually clean the pvc and pv"
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
