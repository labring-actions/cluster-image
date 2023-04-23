#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts && mkdir charts
helm repo add  --force-update neuvector https://neuvector.github.io/neuvector-helm/
chart_version=`helm search repo --versions --regexp '\vneuvector/core\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull neuvector/core --version=${chart_version} -d charts/ --untar
yq e -i '.containerd.enabled = true' charts/core/values.yaml
