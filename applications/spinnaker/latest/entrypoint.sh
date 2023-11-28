#!/usr/bin/env bash
set -e

install_halyard() {
    kubectl apply -f manifests/spinaccount.yaml
    kubectl apply -f manifests/configmap.yaml
    kubectl apply -f manifests/halyard_deployment.yaml

    kubectl rollout status deployment.apps/halyard
}

install_spinnaker(){
    pod_name=$(kubectl get pods -l app=halyard -o jsonpath='{.items[*].metadata.name}')
    kubectl cp scripts/deploy.sh ${pod_name}:/home/spinnaker/ -c halyard
    kubectl cp etc/halconfig.tar.gz ${pod_name}:/home/spinnaker/ -c halyard
    kubectl exec ${pod_name} -c halyard -- mkdir -p /home/spinnaker/.hal/.boms
    kubectl exec ${pod_name} -c halyard -- tar -zxf /home/spinnaker/halconfig.tar.gz -C /home/spinnaker/.hal/.boms --strip=1
    kubectl exec ${pod_name} -c halyard -- bash /home/spinnaker/deploy.sh
}

apply_ingress() {
    kubectl apply -f manifests/spinnakerIngress.yaml
}

install_halyard
install_spinnaker
apply_ingress
