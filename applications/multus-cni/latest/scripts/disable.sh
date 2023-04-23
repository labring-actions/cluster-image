#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function disable(){
  if kubectl -n kube-system get daemonset.apps/kube-multus-ds >/dev/null 2>&1; then
    kubectl delete -f ../manifests/multus-daemonset-thick.yml
    log::info "${NAME} is uninstalled"
  else
    log::info "${NAME} is not exits"
  fi
}
disable
