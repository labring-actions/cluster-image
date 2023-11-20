#!/usr/bin/env bash
set -e

MANIFESTS_DIR="./manifest"

# if ! command -v kustomize >/dev/null 2>&1; then
#     echo "kustomize is not installed, exit"
#     exit 1
# fi

# install spinnaker operator crds
kubectl apply -f ${MANIFESTS_DIR}/deploy/crds/
kubectl wait --for=condition=Established -f ${MANIFESTS_DIR}/deploy/crds/

# install spinnaker operator
kubectl create ns spinnaker-operator &>/dev/null || true
kubectl -n spinnaker-operator apply -f ${MANIFESTS_DIR}/deploy/operator/cluster
kubectl rollout status -w deployment.apps/spinnaker-operator --namespace="spinnaker-operator"

# install spinnaker basic
kubectl create ns spinnaker &>/dev/null || true
kubectl apply -f manifests/

# install spinnaker kustomize
# pushd ${MANIFESTS_DIR}/spinnaker-kustomize-patches-master
# kubectl create ns spinnaker &>/dev/null || true
# kustomize build . | kubectl apply -f -
# popd
