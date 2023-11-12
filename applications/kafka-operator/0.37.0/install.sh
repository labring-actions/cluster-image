#!/bin/bash
NAME=${NAME:-"kafka"}
NAMESPACE=${NAMESPACE:-"kafka-system"}
CHARTS="./charts/strimzi-kafka-operator"
HELM_OPTS=${HELM_OPTS:-""}
helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace  ${HELM_OPTS}
while true; do
    # shellcheck disable=SC2126
    NOT_RUNNING=$(kubectl get pods -n kafka-system --no-headers | grep -v "Running" | wc -l)
    if [[ $NOT_RUNNING -eq 0 ]]; then
        echo "All pods are in Running state for kafka-operator !"
        break
    else
        echo "Waiting for pods to be in Running state for kafka-operator..."
        sleep 2
    fi
done
kubectl apply -f manifests/simplekafkacluster.yaml
