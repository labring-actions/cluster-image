#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/ && mkdir charts
rm -rf manifests && mkdir -p manifests
helm pull oci://docker.io/envoyproxy/gateway-helm --version "${VERSION}" -d charts/ --untar
cp -rf charts/gateway-helm/crds/* manifests/

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
COPY install.sh install.sh
CMD ["bash install.sh"]
EOF
