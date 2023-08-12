#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"piraeus-operator"}
NAMESPACE=${NAMESPACE:-"piraeus-datastore"}
HELM_OPTS=${HELM_OPTS:-"--set installCRDs=true"}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  if ! sealos exec "test -d /lib/modules/$(uname -r)/build/";then
    log::info "Check linux kernel headers failed, exit 1"
    exit 1
  fi
  sealos exec "echo fs.inotify.max_user_instances=8192 | tee -a /etc/sysctl.d/piraeus.conf && sudo sysctl -p"
  helm upgrade -i ${NAME} ./chart/piraeus -n ${NAMESPACE} --create-namespace ${HELM_OPTS} --wait
  kubectl apply -f manifests/linstorcluster.yaml --wait=true
  kubectl apply -f manifests/linstorsatelliteconfiguration.yaml --wait=true 
  kubectl apply -f manifests/piraeus-storageclass.yaml
  sealos scp -r master opt/kubectl-linstor /usr/local/bin/kubectl-linstor
  sealos exec -r master "chmod +x /usr/local/bin/kubectl-linstor"
}

install
