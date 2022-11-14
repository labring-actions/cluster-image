#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

git clone https://github.com/solo-io/gloo.git -b ${VERSION} --depth=1
cp -r gloo/install/helm/gloo/ charts/gloo
rm -rf gloo

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i gloo gloo/gloo -n gloo-system--create-namespace --set gateway.enabled=true,ingress.enabled=true"]
EOF

