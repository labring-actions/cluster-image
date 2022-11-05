#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf manifests/kubevirt images/shim/ opt/
mkdir -p manifests/kubevirt-cdi images/shim/ opt/
curl -L -o opt/virtctl https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-${ARCH}
chmod +x opt/virtctl

wget -q https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-operator.yaml -P manifests/
wget -q https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-cr.yaml -P manifests/

export CDI_TAG=$(curl -s -w %{redirect_url} https://github.com/kubevirt/containerized-data-importer/releases/latest)
export CDI_VERSION=$(echo ${CDI_TAG##*/})
wget -q https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-operator.yaml -P manifests/
wget -q https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-cr.yaml -P manifests/

cat <<EOF >"images/shim/kubevirtImages"
quay.io/kubevirt/virt-api:${VERSION}
quay.io/kubevirt/virt-controller:${VERSION}
quay.io/kubevirt/virt-handler:${VERSION}
quay.io/kubevirt/virt-launcher:${VERSION}
quay.io/kubevirt/virt-operator:${VERSION}
quay.io/kubevirt/cdi-operator:${CDI_VERSION}
quay.io/kubevirt/cdi-apiserver:${CDI_VERSION}
quay.io/kubevirt/cdi-controller:${CDI_VERSION}
quay.io/kubevirt/cdi-uploadproxy:${CDI_VERSION}
quay.io/kubevirt/cdi-importer:${CDI_VERSION}
quay.io/kubevirt/cdi-cloner:${CDI_VERSION}
quay.io/kubevirt/cdi-uploadserver:${CDI_VERSION}
EOF

cat <<EOF >"Kubefile"
FROM scratch
COPY opt opt
COPY manifests manifests
COPY registry registry
CMD ["cp opt/virtctl /usr/local/bin/","kubectl apply -f manifests/kubevirt-operator.yaml","kubectl apply -f manifests/kubevirt-cr.yaml","kubectl apply -f manifests/cdi-operator.yaml","kubectl apply -f manifests/cdi-cr.yaml"]
EOF
