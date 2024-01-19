#!/usr/bin/env bash
set -e

NAME=${NAME:-"milvus"}
NAMESPACE=${NAMESPACE:-"milvus"}
CHARTS=${CHARTS:-"./charts/milvus"}
HELM_OPTS=${HELM_OPTS:-" \
--set cluster.enabled=false \
--set etcd.replicaCount=1 \
--set minio.mode=standalone \
--set pulsar.enabled=false \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
