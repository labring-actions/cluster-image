#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

wget -qO- https://github.com/rancher/local-path-provisioner/archive/refs/tags/${VERSION}.tar.gz | tar xz
mkdir charts
cp -r local-path-provisioner-${VERSION#v}/deploy/chart/local-path-provisioner charts
yq e -i '.storageClass.defaultClass="true"' charts/local-path-provisioner/values.yaml
