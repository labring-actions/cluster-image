#!/usr/bin/env bash
set -e

NAME=${NAME:-"awx"}
NAMESPACE=${NAMESPACE:-"awx"}
CHARTS=${CHARTS:-"./charts/awx-operator"}
HELM_OPTS=${HELM_OPTS:-" \
--set AWX.enabled=true \
--set AWX.spec.service_type=NodePort \
--set AWX.spec.projects_persistence=true \
--set AWX.spec.projects_storage_access_mode=ReadWriteOnce \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
