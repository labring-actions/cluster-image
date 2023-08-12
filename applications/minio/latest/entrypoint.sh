#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"minio"}
NAMESPACE=${NAMESPACE:-"minio"}
HELM_OPTS=${HELM_OPTS:-"--set service.type=NodePort \
--set consoleService.type=NodePort \
--set rootUser=admin \
--set rootPassword=minio123 \
--set replicas=1 \
--set mode=standalone \
--set resources.requests.cpu=250m \
--set resources.requests.memory=256Mi
--set resources.limits.cpu=2 \
--set resources.limits.memory=2Gi
--set persistence.size=10Gi"}

function install(){
  helm upgrade -i ${NAME} ./charts/minio -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

install
