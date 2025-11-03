#!/usr/bin/env bash
set -e

NAME=${NAME:-"cert-manager"}
NAMESPACE=${NAMESPACE:-"cert-manager"}
CHARTS=${CHARTS:-"./charts/cert-manager"}
HELM_OPTS=${HELM_OPTS:-"
--set crds.enabled=true \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS} --wait
if [ -f opt/cmctl ]; then
  cp -f opt/cmctl /usr/local/bin/
fi
