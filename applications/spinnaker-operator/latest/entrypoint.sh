#!/usr/bin/env bash
set -e

ETC_DIR="./etc"
MANIFESTS_DIR="./manifests"

# if ! command -v kustomize >/dev/null 2>&1; then
#     echo "kustomize is not installed, exit"
#     exit 1
# fi

# install spinnaker operator crds
kubectl apply -f ${ETC_DIR}/deploy/crds/
kubectl wait --for=condition=Established -f ${ETC_DIR}/deploy/crds/

# install spinnaker operator
kubectl create ns spinnaker-operator &>/dev/null || true
kubectl -n spinnaker-operator apply -f ${ETC_DIR}/deploy/operator/cluster
kubectl rollout status -w deployment.apps/spinnaker-operator --namespace="spinnaker-operator"

# install spinnaker basic
sleep 10s
kubectl create ns spinnaker &>/dev/null || true
kubectl apply -f ${MANIFESTS_DIR}/spinnakerService.yaml
kubectl apply -f ${MANIFESTS_DIR}/spinnakerIngress.yaml

# install spinnaker kustomize
# pushd ${MANIFESTS_DIR}/spinnaker-kustomize-patches-master
# kubectl create ns spinnaker &>/dev/null || true
# kustomize build . | kubectl apply -f -
# popd
