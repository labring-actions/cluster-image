#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"metallb"}
NAMESPACE=${NAMESPACE:-"metallb-system"}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

if kubectl get configmap kube-proxy -n kube-system >/dev/null 2>&1; then
  kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e 's/strictARP: false/strictARP: true/' | kubectl apply -f - -n kube-system
fi
log::info "waitting metallb start..."
helm upgrade -i ${NAME} ../charts/metallb -n ${NAMESPACE} --create-namespace --wait

if [ ! -z ${addresses} ] && [ -f ../manifests/IPAddressPool.yaml ];then
  kubectl apply -f ../manifests/IPAddressPool.yaml
fi
