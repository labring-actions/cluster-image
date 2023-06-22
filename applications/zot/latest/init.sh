#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

cat <<EOF >"values-${ARCH}.yaml"
image:
  repository: ghcr.io/project-zot/zot-linux-${ARCH}
  tag: "${VERSION}"
EOF

mkdir -p "charts"
cp -rf zot charts/
cat <<EOF >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade --install zot charts/zot --namespace zot --create-namespace --values charts/zot/values.yaml --values charts/zot/values-${ARCH}.yaml"]
EOF
