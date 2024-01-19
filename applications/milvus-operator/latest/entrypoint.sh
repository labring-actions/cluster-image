#!/usr/bin/env bash
set -e

NAME=${NAME:-"milvus-operator"}
NAMESPACE=${NAMESPACE:-"milvus-operator"}
CHARTS=${CHARTS:-"./charts/milvus-operator"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS} --wait --wait-for-jobs

kubectl create ns milvus &>/dev/null || true
kubectl -n milvus apply -f manifest/milvus_default.yaml
