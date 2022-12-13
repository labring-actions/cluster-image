#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  docker run --rm -v "$PWD:/pwd" -w /kube "ghcr.io/labring-actions/cache:kubernetes-v$KUBE-$ARCH" cp -auv crictl.tar.gz /pwd
  case $CRI_TYPE in
  containerd)
    docker run --rm -v "$PWD:/pwd" -w /cri "ghcr.io/labring-actions/cache:cri-$ARCH" cp -auv cri-containerd.tar.gz /pwd
    ;;
  cri-o)
    docker run --rm -v "$PWD:/pwd" -w /kube "ghcr.io/labring-actions/cache:kubernetes-v$KUBE-$ARCH" cp -auv cri-o.tar.gz /pwd
    ;;
  docker)
    case $KUBE in
    1.*.*)
    sudo cp -a "$MOUNT_CRI"/cri-dockerd.tgz .
    sudo cp -a "$MOUNT_CRI"/docker.tgz .
    docker run --rm -v "$PWD:/pwd" -w /cri "ghcr.io/labring-actions/cache:cri-$ARCH" cp -auv cri-dockerd.tgz docker.tgz /pwd
      ;;
    esac
    ;;
  esac
    docker run --rm -v "$PWD:/pwd" -w /cri "ghcr.io/labring-actions/cache:cri-$ARCH" cp -auv registry library.tar.gz lsof /pwd
}

echo "$0"
tree "$ROOT"

