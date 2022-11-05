#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

git clone https://github.com/coder/code-server.git -b ${VERSION} --depth=1
cp -r code-server/ci/helm-chart/ charts/code-server
rm -rf code-server

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i code-server charts/code-server -n code-server --create-namespace --set service.type=NodePort"]
EOF
