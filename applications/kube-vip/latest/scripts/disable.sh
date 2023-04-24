#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME="kube-vip"

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function disable(){
  if [ -f /etc/kubernetes/manifests/kube-vip.yaml ]; then
    sealos exec -r master "rm -rf /etc/kubernetes/manifests/kube-vip.yaml"
    kubectl delete -f ../manifests/cloud-provider/kube-vip-cloud-controller.yaml > /dev/null 2>&1 || true
    kubectl delete -f ../manifests/cloud-provider/kube-vip-configmap.yaml > /dev/null 2>&1 || true
    log::info "${NAME} is uninstalled"
  else
    log::info "${NAME} is not exits"
  fi
}
disable
