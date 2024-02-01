#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
mkdir charts

repo_url="https://github.com/apecloud/helm-charts/releases/download"
charts=( "kubeblocks" "apecloud-mysql")
for chart in "${charts[@]}"; do
  chart_version=${VERSION#v}
  if [[ "$chart" != "kubeblocks" ]]; then
    chart_version=$(cat charts/kubeblocks/templates/addons/$chart-addon.yaml | (grep "\"version\"" || true) | awk '{print $2}'| sed 's/"//g')
    rm -rf charts/kubeblocks
  fi
  helm fetch -d charts --untar "$repo_url"/"${chart}"-"${chart_version}"/"${chart}"-"${chart_version}".tgz
  rm -rf charts/"${chart}"-"${chart_version}".tgz
done
