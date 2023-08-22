#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts images/shim && mkdir -p manifests images/shim

wget -qO- https://github.com/grafana-operator/grafana-operator/archive/refs/tags/${VERSION}.tar.gz | tar -xz
mv grafana-operator-${VERSION#v}/deploy/helm/ charts/

GrafanaImage=$(cat grafana-operator-${VERSION#v}/controllers/config/operator_constants.go |grep GrafanaImage | awk -F "[\"\"]" '{print $2}')
GrafanaVersion=$(cat grafana-operator-${VERSION#v}/controllers/config/operator_constants.go |grep GrafanaVersion | awk -F "[\"\"]" '{print $2}')
echo $GrafanaImage:$GrafanaVersion > images/shim/grafana-operator-images.txt

rm -rf grafana-operator-${VERSION#v}

#wget -qP manifests/ https://raw.githubusercontent.com/grafana-operator/grafana-operator/${VERSION}/examples/basic/resources.yaml
