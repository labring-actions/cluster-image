#!/bin/bash

set -eux

readonly ARCH=${arch?}
readonly SEALOS=${sealoslatest?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  FROM_KUBE=$(sudo buildah from --name "sealos-v$SEALOS-$ARCH" "ghcr.io/labring-actions/cache:sealos-v$SEALOS-$ARCH")
  sudo cp -a "$(sudo buildah mount "$FROM_KUBE")"/sealos/image-cri-shim .
  sudo cp -a "$(sudo buildah mount "$FROM_KUBE")"/sealos/sealctl .
  sudo buildah umount "$FROM_KUBE"
}

echo "$0"
tree "$ROOT"
