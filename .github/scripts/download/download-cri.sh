#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

sudo buildah from --name "kubernetes-v$KUBE-$ARCH" "ghcr.io/labring-actions/cache:kubernetes-v$KUBE-$ARCH"
readonly MOUNT_KUBE=$(sudo buildah mount "kubernetes-v$KUBE-$ARCH")
sudo buildah from --name "cri-$ARCH" "ghcr.io/labring-actions/cache:cri-$ARCH"
readonly MOUNT_CRI="$(sudo buildah mount "cri-$ARCH")"

cd "$ROOT" && {
  sudo cp -a "$MOUNT_KUBE"/v$KUBE/crictl.tar.gz .
  case $CRI_TYPE in
  containerd)
    sudo cp -a "$MOUNT_CRI"/cri-containerd.tar.gz .
    ;;
  cri-o)
    sudo cp -a "$MOUNT_KUBE"/v$KUBE/cri-o.tar.gz .
    ;;
  docker)
    case $KUBE in
    1.*.*)
    sudo cp -a "$MOUNT_CRI"/cri-dockerd.tgz .
    sudo cp -a "$MOUNT_CRI"/docker.tgz .
      ;;
    esac
    ;;
  esac
    sudo cp -a "$MOUNT_CRI"/registry .
    sudo cp -a "$MOUNT_CRI"/library.tar.gz .
    sudo cp -a "$MOUNT_CRI"/lsof .
}

sudo buildah umount "kubernetes-v$KUBE-$ARCH"
sudo buildah umount "cri-$ARCH"

echo "$0"
tree "$ROOT"

