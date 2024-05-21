#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"minecraft"}
NAMESPACE=${NAMESPACE:-"minecraft"}
CHARTS=${CHARTS:-"./charts/minecraft"}
HELM_OPTS=${HELM_OPTS:-" \
--set minecraftServer.eula=true \
--set persistence.dataDir.enabled=true \
--set minecraftServer.serviceType=NodePort \
--set minecraftServer.onlineMode=false"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
