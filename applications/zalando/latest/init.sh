#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
mkdir charts

repo_url="https://opensource.zalando.com/postgres-operator/charts/postgres-operator"

helm repo add postgres-operator-charts ${repo_url}

helm fetch -d charts --untar postgres-operator-charts/postgres-operator --version ${VERSION}

rm -rf charts/"${chart}"-"${VERSION#v}".tgz

