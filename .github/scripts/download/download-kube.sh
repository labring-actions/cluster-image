#!/bin/bash

set -e

readonly ARCH=${arch?}
readonly KUBE=${kubeVersion?}

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  docker run --rm -v "$PWD:/pwd" -w /kube "ghcr.io/labring-actions/cache:kubernetes-v$KUBE-$ARCH" cp -auv . /pwd
}

echo "$0"
tree "$ROOT"
