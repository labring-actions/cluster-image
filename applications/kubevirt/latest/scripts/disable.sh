#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=kubevirt

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function disable(){
  log::info "uninstalling ${NAME}..."
  kubectl delete -n kubevirt kubevirt kubevirt --wait=true
  kubectl delete -f ../manifests/kubevirt/kubevirt-operator.yaml --wait=false
  kubectl delete -f ../manifests/kubevirt-cdi/cdi-cr.yaml
  kubectl delete -f ../manifests/kubevirt-cdi/cdi-operator.yaml
  sealos exec -r master "rm -rf /usr/local/bin/virtctl"
  log::info "${NAME} is uninstalled"
}
disable
