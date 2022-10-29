#!/bin/bash

#set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf opt/ images/shim/
rm -rf flux_*
mkdir -p opt/ images/shim/
wget -q https://github.com/fluxcd/flux2/releases/download/v${VERSION}/flux_${VERSION}_linux_${ARCH}.tar.gz
tar -zxvf flux_${VERSION}_linux_${ARCH}.tar.gz -C opt/
./opt/flux install --version v${VERSION} --export --components-extra="image-reflector-controller,image-automation-controller" |grep ghcr.io | awk '{print $2}' > images/shim/images-list.txt

cat <<EOF >"Kubefile"
FROM scratch
COPY opt opt
COPY registry registry
CMD ["cp opt/flux /usr/bin/","flux install --version v${VERSION} --components-extra='image-reflector-controller,image-automation-controller'"]
EOF
