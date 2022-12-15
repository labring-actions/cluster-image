#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly SEALOS=${sealoslatest?}
readonly IMAGE_CACHE_NAME="ghcr.io/labring-actions/cache"
readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  FROM_SEALOS=$(sudo buildah from --name "sealos-v$SEALOS-$ARCH" "$IMAGE_CACHE_NAME:sealos-v$SEALOS-$ARCH")
  sudo cp -a "$(sudo buildah mount "$FROM_SEALOS")"/sealos/image-cri-shim .
  sudo cp -a "$(sudo buildah mount "$FROM_SEALOS")"/sealos/sealctl .
  sudo buildah umount "$FROM_SEALOS"
}

echo "$0"
tree "$ROOT"
