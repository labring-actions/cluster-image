#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
mkdir charts
repo_url="https://github.com/apecloud/helm-charts/releases/download"
charts=("kubeblocks-cloud")
for chart in "${charts[@]}"; do
    helm fetch -d charts --untar "$repo_url"/"${chart}"-"${VERSION}"/"${chart}"-"${VERSION}".tgz
    values_file="charts/${charts}/values.yaml"
    echo "${CLOUD_VALUES}" > $values_file
    rm -rf charts/"${chart}"-"${VERSION}".tgz
done
