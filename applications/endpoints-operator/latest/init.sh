#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/
mkdir -p images/shim

echo "ghcr.io/labring/cepctl:$VERSION" > images/shim/cepctl
wget -qO charts/endpoints-operator.tgz https://github.com/labring/endpoints-operator/releases/download/v${VERSION#v}/endpoints-operator-${VERSION#v}.tgz

cat <<'EOF' >"Kubefile"
FROM scratch
ENV HELM_OPTS=""
COPY charts ./charts
COPY images ./images
COPY registry ./registry
CMD ["helm upgrade -n kube-system  endpoints-operator charts/endpoints-operator.tgz --install \$(HELM_OPTS)"]
EOF

