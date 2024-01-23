#!/usr/bin/env bash
set -e

NAMESPACE=${NAMESPACE:-"milvus"}

kubectl create ns ${NAMESPACE} &>/dev/null || true
kubectl -n ${NAMESPACE} apply -f manifests/attu-k8s-deploy.yaml
