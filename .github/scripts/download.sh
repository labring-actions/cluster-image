#!/bin/bash

set -eu

readonly HELM=${helmVersion:-3.9.4}
readonly SEALOS=${sealos?}

readonly ROOT="/tmp/$(whoami)/bin"
mkdir -p "$ROOT"

cd "$ROOT" && {
  wget -qO- "https://github.com/labring/sealos/releases/download/v$SEALOS/sealos_${SEALOS}_linux_amd64.tar.gz" |
    tar -zx sealos
  wget -qO- "https://get.helm.sh/helm-v$HELM-linux-amd64.tar.gz" |
    tar -zx linux-amd64/helm --strip-components=1
  wget -qO "buildah" "https://github.com/labring/cluster-image/releases/download/depend/buildah.linux.amd64"
}

echo "$0"
tree "$ROOT"
