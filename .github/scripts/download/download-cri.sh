#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

FROM_KUBE=$(sudo buildah from --name "cri-v${KUBE%.*}-$ARCH" "ghcr.io/labring-actions/cache:cri-v${KUBE%.*}-$ARCH")
readonly MOUNT_CRIO=$(sudo buildah mount "$FROM_KUBE")
FROM_CRI=$(sudo buildah from --name "cri-$ARCH" "ghcr.io/labring-actions/cache:cri-$ARCH")
readonly MOUNT_CRI=$(sudo buildah mount "$FROM_CRI")

cd "$ROOT" && {
  sudo cp -a "$MOUNT_CRIO"/cri/crictl.tar.gz .
  case $CRI_TYPE in
  containerd)
    sudo cp -a "$MOUNT_CRI"/cri/cri-containerd.tar.gz .
    ;;
  cri-o)
    sudo cp -a "$MOUNT_CRIO"/cri/cri-o.tar.gz .
    ;;
  docker)
    case $KUBE in
    1.*.*)
    sudo cp -a "$MOUNT_CRI"/cri/cri-dockerd.tgz .
    sudo cp -a "$MOUNT_CRI"/cri/docker.tgz .
      ;;
    esac
    ;;
  esac
    sudo cp -a "$MOUNT_CRI"/cri/registry .
    sudo cp -a "$MOUNT_CRI"/cri/library.tar.gz .
    sudo cp -a "$MOUNT_CRI"/cri/lsof .
}

sudo buildah umount "$FROM_KUBE" "$FROM_CRI"

echo "$0"
tree "$ROOT"

