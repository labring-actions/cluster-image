#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
mkdir charts
repo_url="https://jihulab.com/api/v4/projects/${CHART_PROJECT_ID}/packages/helm/stable"
repo_name="kb-ent"
helm repo add ${repo_name} --username ${CHART_ACCESS_USER} --password ${CHART_ACCESS_TOKEN} $repo_url
helm repo update ${repo_name}

charts=("starrocks")
for chart in "${charts[@]}"; do
    helm pull -d charts --untar ${repo_name}/${chart} --version ${VERSION}
done
