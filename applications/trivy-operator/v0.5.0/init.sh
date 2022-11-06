#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/ images/shim/
mkdir -p charts/ images/shim/

# Remove `v` from image tag `vx.x.x`
chart_version=`echo ${VERSION} | sed 's/.//'`

helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm pull aqua/trivy-operator --version=${chart_version} -d charts/ --untar

# Parse trivy image tag
trivy_tag=`helm show values charts/trivy-operator --jsonpath '{.trivy.tag}'`
echo "ghcr.io/aquasecurity/trivy:$trivy_tag" > images/shim/trivyImages

cat <<EOF >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i trivy-operator charts/trivy-operator -n trivy-system --create-namespace --set trivy.ignoreUnfixed=true"]
EOF
