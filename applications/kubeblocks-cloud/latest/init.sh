#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly IMAGE_HUB_USERNAME=${4:-""}
export readonly IMAGE_HUB_PASSWORD=${5:-""}
export readonly IMAGE_HUB_EMAIL=${6:-""}

rm -rf charts
mkdir charts

repo_url="https://github.com/apecloud/helm-charts/releases/download"
charts=("kubeblocks-cloud")
for chart in "${charts[@]}"; do
    helm fetch -d charts --untar "$repo_url"/"${chart}"-"${VERSION}"/"${chart}"-"${VERSION}".tgz \
        --set imageCredentials.registry="https://index.docker.io/v1/" \
        --set imageCredentials.username="${IMAGE_HUB_USERNAME}" \
        --set imageCredentials.password="${IMAGE_HUB_PASSWORD}" \
        --set imageCredentials.email="${IMAGE_HUB_EMAIL}"
    rm -rf charts/"${chart}"-"${VERSION}".tgz
done
