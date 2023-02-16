#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

helm repo add datawire  https://app.getambassador.io
helm pull datawire/telepresence --version=${VERSION} -d charts/ --untar
rm -rf charts/telepresence/templates/tests
cat <<EOF >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i traffic-manager charts/telepresence -n ambassador --create-namespace"]
EOF
