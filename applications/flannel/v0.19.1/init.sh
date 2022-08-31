#!/bin/bash

set -eux

readonly ARCH=${1:-amd64}
readonly NAME=${2:-flannel}
readonly VERSION=${3:-v0.19.1}

mkdir -p manifests
cd manifests && {
  if ! [[ -s kube-flannel.yml ]]; then
    wget -q "https://github.com/$NAME-io/$NAME/raw/v${VERSION#*v}/Documentation/kube-flannel.yml"
  fi
  sed -i 's#10.244.0.0/16#100.64.0.0/10#g' kube-flannel.yml
  cd -
}

echo "Fix missing CNI plugins with add initContainers named install-cni-plugins"
