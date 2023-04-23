#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function enable(){
  kubectl apply -f ../manifests/kubevirt/kubevirt-operator.yaml
  kubectl apply -f ../manifests/kubevirt/kubevirt-cr.yaml
  kubectl apply -f ../manifests/kubevirt-cdi/cdi-operator.yaml
  kubectl apply -f ../manifests/kubevirt-cdi/cdi-cr.yaml
  sealos scp -r master ../opt/virtctl /usr/local/bin/virtctl
}
enable
