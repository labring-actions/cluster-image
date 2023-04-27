#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts-untar/

helm repo add datawire  https://app.getambassador.io
helm pull datawire/telepresence --version=${VERSION} -d charts-untar/ --untar
rm -rf charts-untar/telepresence/templates/tests
mkdir -p manifests
helm template traffic-manager charts-untar/telepresence --debug > manifests/telepresence-charts.yaml

mkdir -p "opt/$NAME"
pushd "opt/$NAME" && {
  [ -s telepresence ] || wget -qO telepresence "https://app.getambassador.io/download/tel2/linux/""${ARCH}""/${VERSION}/telepresence"
  chmod a+x ./*
}
popd

cat <<EOF >"Kubefile"
FROM scratch
COPY charts-untar charts
COPY registry registry
COPY opt opt
CMD ["cp opt/telepresence /usr/bin/","helm upgrade -i traffic-manager charts/telepresence -n ambassador --create-namespace"]
EOF
