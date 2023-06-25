#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir -p images/shim
echo "ghcr.io/labring/lvscare:$VERSION" > images/shim/lvscare

wget https://github.com/labring/sealos/releases/download/"$VERSION"/sealos_"${VERSION#v}"_linux_amd64.tar.gz
tar -zxvf sealos_"${VERSION#v}"_linux_"${ARCH}".tar.gz sealos sealctl image-cri-shim

cat <<EOF >>"Kubefile"
FROM scratch
LABEL image="ghcr.io/labring/lvscare:$VERSION"
LABEL sealos.io.type="patch"
COPY images ./images
COPY registry ./registry
COPY sealctl ./opt/sealctl
COPY image-cri-shim ./cri/image-cri-shim
EOF
