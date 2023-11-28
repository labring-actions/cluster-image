#!/usr/bin/env bash
set -e

NAME=${NAME:-"gitness"}
NAMESPACE=${NAMESPACE:-"gitness"}
CHARTS=${CHARTS:-"./charts/gitness"}
HELM_OPTS=${HELM_OPTS:-" \
--set service.type=NodePort \
--set env.GITNESS_PRINCIPAL_ADMIN_PASSWORD=gitness \
--set env.GITNESS_USER_SIGNUP_ENABLED=false \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
