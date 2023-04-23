#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

if [ ! -z ${kube_vip_address} ]; then
  sealos scp -r master ../manifests/kube-vip.yaml /etc/kubernetes/manifests/kube-vip.yaml
else
  log::info "kube_vip_address env not found, please run with -e kube_vip_address=<your-kube_vip_address>, exit"
  exit 1
fi

if [ ! -z ${controller_enabled} ] && [ -f ../manifests/cloud-provider/kube-vip-configmap.yaml ] && ([ ! -z ${cidr_global} ] || [ ! -z ${range_global} ]); then
  kubectl apply -f ../manifests/cloud-provider/kube-vip-cloud-controller.yaml
  kubectl apply -f ../manifests/cloud-provider/kube-vip-configmap.yaml
fi
