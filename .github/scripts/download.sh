#!/bin/bash

set -e

SEALOS=${sealos?}
HELM=${helm:-3.8.2}

TARGET="/usr/bin"

if wget -qO- "https://github.com/labring/sealos/releases/download/v$SEALOS/sealos_${SEALOS}_linux_amd64.tar.gz" |
  tar -zx sealos; then
  chmod a+x sealos
  sudo mv sealos "$TARGET"
else
  echo "====download and targz sealos failed!===="
fi

if wget -qO- "https://get.helm.sh/helm-v$HELM-linux-amd64.tar.gz" |
  tar -zx linux-amd64/helm --strip-components=1; then
  chmod a+x helm
  sudo mv helm "$TARGET"
else
  echo "====download and targz helm failed!===="
fi

if wget -qO buildah "https://github.com/labring/cluster-image/releases/download/depend/buildah.linux.amd64"; then
  chmod a+x buildah
  sudo mv buildah "$TARGET"
else
  echo "====download buildah failed!===="
fi
