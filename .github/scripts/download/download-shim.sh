#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly SEALOS=${sealoslatest?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  docker run --rm -v "$PWD:/pwd" -w /sealos "ghcr.io/labring-actions/cache:sealos-v$SEALOS-$ARCH" cp -auv image-cri-shim sealctl /pwd
}

echo "$0"
tree "$ROOT"
