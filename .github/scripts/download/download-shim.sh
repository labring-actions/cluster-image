#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly SEALOS=${sealoslatest?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  sudo buildah from --name "sealos-v$SEALOS-$ARCH" "ghcr.io/labring-actions/cache:sealos-v$SEALOS-$ARCH"
  sudo cp -a "$(sudo buildah mount "sealos-v$SEALOS-$ARCH")"/v$SEALOS/image-cri-shim .
  sudo cp -a "$(sudo buildah mount "sealos-v$SEALOS-$ARCH")"/v$SEALOS/sealctl .
  sudo buildah umount "sealos-v$SEALOS-$ARCH"
}

echo "$0"
tree "$ROOT"
