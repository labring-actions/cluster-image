#!/bin/bash

set -eux

readonly ARCH=${arch?}
readonly SEALOS=${sealoslatest?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  until curl -sL "https://github.com/labring/sealos/releases/download/v$SEALOS/sealos_${SEALOS}_linux_${ARCH}.tar.gz"; do sleep 3; done |
    tar -zx image-cri-shim
  until curl -sL "https://github.com/labring/sealos/releases/download/v$SEALOS/sealos_${SEALOS}_linux_${ARCH}.tar.gz"; do sleep 3; done |
    tar -zx sealctl
}

echo "$0"
tree "$ROOT"
