#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf manifests/ && mkdir manifests
wget -qP manifests/ https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/${VERSION}/deployments/multus-daemonset.yml

cat <<EOF >>"Kubefile"
FROM scratch
COPY manifests manifests
COPY registry registry
CMD ["kubectl apply -f manifests/multus-daemonset.yml"]
EOF
