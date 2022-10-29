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

cat <<EOF >"Kubefile"
FROM scratch
COPY manifests manifests
COPY registry registry
CMD ["kubectl apply -f manifests/kubesphere-installer.yaml","kubectl apply -f manifests/cluster-configuration.yaml"]
EOF
