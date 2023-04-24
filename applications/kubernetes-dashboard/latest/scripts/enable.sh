#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"kubernetes-dashboard"}
NAMESPACE=${NAMESPACE:-"kubernetes-dashboard"}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function enable(){
  helm upgrade -i ${NAME} ../charts/kubernetes-dashboard -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
  if [ -f ../manifests/dashboard-adminuser.yaml ]; then
    kubectl apply -f ../manifests/dashboard-adminuser.yaml
    log::info "Get the Kubernetes Dashboard Login token by running:
    kubectl -n ${NAMESPACE} get secrets admin-user -o go-template='{{.data.token | base64decode}}'"
  fi
}
enable
