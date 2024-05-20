#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
mkdir charts

repo_url="https://github.com/apecloud/helm-charts/releases/download"
charts=("spiderpool")
for chart in "${charts[@]}"; do
    helm fetch -d charts --untar "$repo_url"/"${chart}"-"${VERSION#v}"/"${chart}"-"${VERSION#v}".tgz
    values_file="charts/${charts}/values.yaml"
    yq e -i '.multus.multusCNI.install=false' $values_file
    yq e -i '.spiderpoolAgent.image.registry=docker.io' $values_file
    yq e -i '.spiderpoolAgent.image.repository=apecloud/spiderpool-agent' $values_file
    yq e -i '.spiderpoolAgent.image.tag=eb82b45a097ad23906e72199b70e25d161fbe88d' $values_file
    yq e -i '.spiderpoolController.image.registry=docker.io' $values_file
    yq e -i '.spiderpoolController.image.repository=apecloud/spiderpool-controller' $values_file
    yq e -i '.spiderpoolController.image.tag=eb82b45a097ad23906e72199b70e25d161fbe88d' $values_file
    rm -rf charts/"${chart}"-"${VERSION#v}".tgz
done
