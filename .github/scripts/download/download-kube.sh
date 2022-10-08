#!/bin/bash

set -e

readonly ARCH=${arch?}
readonly KUBE=${kubeVersion?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  until wget -qO "kubectl" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubectl"; do sleep 3; done
  until wget -qO "kubelet" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubelet"; do sleep 3; done
  until wget -qO "kubeadm" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubeadm"; do sleep 3; done
}

echo "$0"
tree "$ROOT"
