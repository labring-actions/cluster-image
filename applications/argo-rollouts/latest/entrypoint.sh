#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"argo-rollouts"}
NAMESPACE=${NAMESPACE:-"argo-rollouts"}
HELM_OPTS=${HELM_OPTS:-" \
--set dashboard.enabled=true \
--set dashboard.service.type=NodePort \
"}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  helm upgrade -i ${NAME} ./charts/${NAME} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
  sealos scp -r master opt/kubectl-argo-rollouts /usr/local/bin/kubectl-argo-rollouts
}

install
