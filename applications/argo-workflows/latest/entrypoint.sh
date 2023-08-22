#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"argo-workflows"}
NAMESPACE=${NAMESPACE:-"argo-workflows"}
HELM_OPTS=${HELM_OPTS:-" \
--set server.serviceType=NodePort \
--set server.extraArgs[0]=--auth-mode=server \
"}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  helm upgrade -i ${NAME} ./charts/${NAME} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
  sealos scp -r master opt/argo /usr/local/bin/argo
}

install
