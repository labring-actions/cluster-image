#!/bin/bash
NAME=${NAME:-"koperator"}
NAMESPACE=${NAMESPACE:-"koperator-system"}
CHARTS="./charts/kafka-operator"
HELM_OPTS=${HELM_OPTS:-""}
kubectl create --validate=false -f crds/kafka-operator.crds.yaml 2>/dev/null || true
kubectl replace --validate=false -f crds/kafka-operator.crds.yaml
helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace --set certManager.namespace=cert-manager --set prometheusMetrics.enabled=true ${HELM_OPTS}
kubectl apply -f manifests/simplekafkacluster.yaml
