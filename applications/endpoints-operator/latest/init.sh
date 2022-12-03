#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/
mkdir -p images/shim

helm repo add endpoints-operator --force-update https://labring.github.io/endpoints-operator/
if [ $VERSION = "latest" ]
then
  helm pull endpoints-operator/endpoints-operator --untar -d charts/
  echo "ghcr.io/labring/cepctl:latest" > images/shim/cepctl
else
  helm pull endpoints-operator/endpoints-operator --version=$VERSION --untar -d charts/
  echo "ghcr.io/labring/cepctl:$VERSION" > images/shim/cepctl
fi

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts ./charts
COPY images ./images
COPY registry ./registry
CMD ["helm upgrade -n kube-system  endpoints-operator charts/endpoints-operator --install"]
EOF

