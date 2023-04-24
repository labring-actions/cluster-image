#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

log::info "download virtctl"
rm -rf manifests images opt
mkdir -p manifests/{kubevirt,kubevirt-cdi} images/shim/ opt/
curl -s -L -o opt/virtctl https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-${ARCH}
chmod +x opt/virtctl

log::info "download kubevirt yaml"
wget -q -N -P manifests/kubevirt https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-operator.yaml
wget -q -N -P manifests/kubevirt https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-cr.yaml

log::info "download kubevirt-cdi yaml"
export CDI_TAG=$(curl -s -w %{redirect_url} https://github.com/kubevirt/containerized-data-importer/releases/latest)
export CDI_VERSION=$(echo ${CDI_TAG##*/})
wget -q -N -P manifests/kubevirt-cdi https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-operator.yaml
wget -q -N -P manifests/kubevirt-cdi https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-cr.yaml

log::info "generate kubevirt images list"
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
