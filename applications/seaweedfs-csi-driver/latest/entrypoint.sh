#!/usr/bin/env bash
set -e

NAME=${NAME:-"seaweedfs-csi-driver"}
NAMESPACE=${NAMESPACE:-"seaweedfs"}
CHARTS=${CHARTS:-"./charts/seaweedfs-csi-driver"}
HELM_OPTS=${HELM_OPTS:-" \
--set seaweedfsFiler=seaweedfs-filer:8888 \
--set isDefaultStorageClass=true \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
