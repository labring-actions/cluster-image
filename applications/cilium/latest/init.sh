#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
mkdir charts

repo_url="https://github.com/apecloud/helm-charts/releases/download"
charts=("cilium")
for chart in "${charts[@]}"; do
    helm fetch -d charts --untar "$repo_url"/"${chart}"-"${VERSION#v}"/"${chart}"-"${VERSION#v}".tgz
    yq e -i '.proxy.sidecarImageRegex=cilium/istio_proxy:1.10.3' charts/${chart}/values.yaml
    rm -rf charts/"${chart}"-"${VERSION#v}".tgz
done
