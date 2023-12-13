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
    new_values_file="charts/${charts}/new_values.yaml"
    touch $new_values_file
    echo "${CLOUD_VALUES}" > $new_values_file
    values_file="charts/${charts}/values.yaml"
    yq e -i '. *= load("'${new_values_file}'")' $values_file
    yq e -i '.images.apiserver.tag="'${VERSION}'"' $values_file
    yq e -i '.images.sentry.tag="'${VERSION}'"' $values_file
    yq e -i '.images.sentryInit.tag="'${VERSION}'"' $values_file
    yq e -i '.images.prompt.tag="'${VERSION}'"' $values_file
    yq e -i '.images.openconsole.managedTag="managed-'${VERSION}'"' $values_file
    yq e -i '.images.openconsole.anywhereTag="anywhere-'${VERSION}'"' $values_file
    yq e -i '.images.openconsole.defaultTag="default-'${VERSION}'"' $values_file

    rm -rf charts/"${chart}"-"${VERSION}".tgz
done
