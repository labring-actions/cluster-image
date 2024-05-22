#!/usr/bin/env bash
set -e

NAME=${NAME:-"cubefs"}
NAMESPACE=${NAMESPACE:-"cubefs"}
CHARTS=${CHARTS:-"./charts/cubefs"}
HELM_OPTS=${HELM_OPTS:-" \
--set image.server=cubefs/cfs-server:v3.3.0 \
--set image.client=cubefs/cfs-client:v3.3.0 \
--set metanode.total_mem=4294967296 \
--set metanode.resources.enabled=false \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
