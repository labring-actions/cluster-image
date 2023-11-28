#!/usr/bin/env bash
set -e

NAME=${NAME:-"cert-manager"}
NAMESPACE=${NAMESPACE:-"cert-manager"}
CHARTS=${CHARTS:-"./charts/cert-manager"}
HELM_OPTS=${HELM_OPTS:-"
--set installCRDs=true \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS} --wait
cp -f opt/cmctl /usr/local/bin/
