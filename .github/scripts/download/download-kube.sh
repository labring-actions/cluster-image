#!/bin/bash

set -ex

readonly ARCH=${arch?}
readonly KUBE=${kubeVersion?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  sudo buildah from --name "kubernetes-v$KUBE-$ARCH" "ghcr.io/labring-actions/cache:kubernetes-v$KUBE-$ARCH"
  sudo cp -a "$(sudo buildah mount "kubernetes-v$KUBE-$ARCH")"/kube/kubeadm .
  sudo cp -a "$(sudo buildah mount "kubernetes-v$KUBE-$ARCH")"/kube/kubectl .
  sudo cp -a "$(sudo buildah mount "kubernetes-v$KUBE-$ARCH")"/kube/kubelet .
  sudo buildah umount "kubernetes-v$KUBE-$ARCH"
}

echo "$0"
tree "$ROOT"
