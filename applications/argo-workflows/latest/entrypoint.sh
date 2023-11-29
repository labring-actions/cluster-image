#!/usr/bin/env bash
set -e

NAME=${NAME:-"argo-workflows"}
NAMESPACE=${NAMESPACE:-"argo-workflows"}
CHARTS=${CHARTS:-"./charts/argo-workflows"}
HELM_OPTS=${HELM_OPTS:-" \
--set server.serviceType=NodePort \
--set server.extraArgs[0]=--auth-mode=server \
--set workflow.serviceAccount.create=true \
--set controller.workflowDefaults.spec.serviceAccountName=argo-workflow \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
cp -p -f opt/argo /usr/local/bin/argo
