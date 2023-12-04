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
    if [[ "$charts" == "kubeblocks-cloud" ]]; then
        cloud_values_file="charts/${charts}/kubeblocks-cloud-values.yaml"
        touch $cloud_values_file
        tee -a $cloud_values_file > /dev/null << EOF
${CLOUD_VALUES}
EOF
    fi
    rm -rf charts/"${chart}"-"${VERSION}".tgz
done
