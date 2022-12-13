#!/bin/bash

set -e

readonly ARCH=${arch?}
readonly KUBE=${kubeVersion?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  FROM_KUBE=$(sudo buildah from "ghcr.io/labring-actions/cache:kubernetes-v$KUBE-$ARCH")
  sudo cp -a "$(sudo buildah mount "$FROM_KUBE")"/kube/kubeadm .
  sudo cp -a "$(sudo buildah mount "$FROM_KUBE")"/kube/kubectl .
  sudo cp -a "$(sudo buildah mount "$FROM_KUBE")"/kube/kubelet .
  sudo buildah umount "$FROM_KUBE"
}

echo "$0"
tree "$ROOT"
