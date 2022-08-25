#!/bin/bash

set -e

readonly ARCH=${arch?}
readonly KUBE=${kubeVersion?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  wget -q "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubectl"
  wget -q "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubelet"
  wget -q "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubeadm"
}

echo "$0"
tree "$ROOT"
