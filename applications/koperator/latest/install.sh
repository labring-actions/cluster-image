#!/bin/bash
NAME=${NAME:-"koperator"}
NAMESPACE=${NAMESPACE:-"koperator-system"}
CHARTS="./charts/kafka-operator"
HELM_OPTS=${HELM_OPTS:-""}
kubectl create --validate=false -f crds/kafka-operator.crds.yaml 2>/dev/null || true
sleep 1
kubectl replace --validate=false -f crds/kafka-operator.crds.yaml
helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace --set certManager.namespace=cert-manager --set alertManager.enable=false  --set prometheusMetrics.enabled=true ${HELM_OPTS}
while true; do
    # shellcheck disable=SC2126
    NOT_RUNNING=$(kubectl get pods -n koperator-system --no-headers | grep -v "Running" | wc -l)
    if [[ $NOT_RUNNING -eq 0 ]]; then
        echo "All pods are in Running state for koperator!"
        break
    else
        echo "Waiting for pods to be in Running state for koperator..."
        sleep 2
    fi
done
kubectl apply -f manifests/simplekafkacluster.yaml
