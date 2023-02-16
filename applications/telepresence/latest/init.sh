#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

# Remove `v` from image tag `vx.x.x`
chart_version=`echo ${VERSION} | sed 's/.//'`

helm repo add datawire  https://app.getambassador.io
helm pull datawire/telepresence --version=${chart_version} -d charts/ --untar

cat <<EOF >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i traffic-manager charts/telepresence -n ambassador --create-namespace"]
EOF
