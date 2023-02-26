#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf manifests/ images/shim/
mkdir -p manifests/ images/shim/
wget -q https://github.com/kubesphere/ks-installer/releases/download/${VERSION}/kubesphere-installer.yaml -P manifests/
wget -q https://github.com/kubesphere/ks-installer/releases/download/${VERSION}/cluster-configuration.yaml -P manifests/
wget -q https://github.com/kubesphere/ks-installer/releases/download/${VERSION}/images-list.txt -P images/shim/
# fix kubectl image version
sed -i "s#kubesphere/kubectl:v1.20.0#kubesphere/kubectl:v1.22.0#g" images/shim/images-list.txt
