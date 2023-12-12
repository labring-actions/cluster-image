#!/usr/bin/env bash
set -e

NAME=${NAME:-"argo-events"}
NAMESPACE=${NAMESPACE:-"argo-events"}
CHARTS=${CHARTS:-"./charts/argo-events"}
HELM_OPTS=${HELM_OPTS:-" \
--set openshift=false \
--set webhook.enabled=true \
--set workflow.serviceAccount.create=true \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
cp -p -f opt/argo-events /usr/local/bin/argo-events
