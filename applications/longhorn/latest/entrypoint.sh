#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"longhorn"}
NAMESPACE=${NAMESPACE:-"longhorn-system"}
CHARTS="./charts/longhorn"
HELM_OPTS=${HELM_OPTS:-" \
--set service.ui.type=NodePort \
"}

function install(){
  cp opt/jq /usr/local/bin/
  chmod +x /usr/local/bin/jq

  kubectl apply -f manifests/longhorn-iscsi-installation.yaml
  kubectl rollout status daemonset.apps/longhorn-iscsi-installation

  kubectl apply -f manifests/longhorn-nfs-installation.yaml
  kubectl rollout status daemonset.apps/longhorn-nfs-installation

  bash scripts/environment_check.sh

  helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

install
