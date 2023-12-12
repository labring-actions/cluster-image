#!/usr/bin/env bash
set -e

NAME=${NAME:-"tidb-operator"}
NAMESPACE=${NAMESPACE:-"tidb-admin"}
CHARTS=${CHARTS:-"./charts/tidb-operator"}
HELM_OPTS=${HELM_OPTS:-""}

kubectl create -f manifest/crd.yaml
helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS} --wait

kubectl create namespace tidb-cluster
kubectl -n tidb-cluster apply -f manifest/examples/basic/tidb-cluster.yaml
kubectl -n tidb-cluster apply -f manifest/examples/basic/tidb-dashboard.yaml
kubectl -n tidb-cluster apply -f manifest/examples/basic/tidb-monitor.yaml
