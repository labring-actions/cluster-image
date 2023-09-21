#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
mkdir charts

repo_url="https://jihulab.com/api/v4/projects/85949/packages/helm/stable/charts"
charts=( "csi-s3")
for chart in "${charts[@]}"; do
  helm fetch -d charts --untar "$repo_url"/"${chart}"-"${VERSION#v}".tgz
  rm -rf charts/"${chart}"-"${VERSION#v}".tgz
done
