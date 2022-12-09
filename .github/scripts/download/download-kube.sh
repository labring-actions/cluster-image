#!/bin/bash

set -ex

readonly ARCH=${arch?}
readonly KUBE=${kubeVersion?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  until curl -sLo "kubectl" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubectl"; do sleep 3; done
  until curl -sLo "kubelet" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubelet"; do sleep 3; done
  until curl -sLo "kubeadm" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubeadm"; do sleep 3; done
}

echo "$0"
tree "$ROOT"
