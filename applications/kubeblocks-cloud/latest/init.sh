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
    helm fetch -d charts --untar "$repo_url"/"${chart}"-"${VERSION}"/"${chart}"-"${VERSION}".tgz
    charts_values=charts/${chart}/values.yaml
    index_num=$( grep -n "imageCredentials:" ${charts_values} )
    index_num=${index_num%%:*}
    echo "index_num:${index_num}"
    registry_num=$(( $index_num + 1 ))
    username_num=$(( $index_num + 2 ))
    password_num=$(( $index_num + 3 ))
    email_num=$(( $index_num + 4 ))
    sed -i "${registry_num}s/^  registry:.*/  registry: \"https:\/\/index.docker.io\/v1\/\"/g" ${charts_values}
    sed -i "${username_num}s/^  username:.*/  username: \"${IMAGE_HUB_USERNAME}\"/g" ${charts_values}
    sed -i "${password_num}s/^  password:.*/  password: \"${IMAGE_HUB_USERNAME}\"/g" ${charts_values}
    sed -i "${email_num}s/^  email:.*/  email: \"${IMAGE_HUB_USERNAME}\"/g" ${charts_values}
    rm -rf charts/"${chart}"-"${VERSION}".tgz
done
