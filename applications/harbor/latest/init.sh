#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

helm repo add harbor https://helm.goharbor.io

chart_version=`helm search repo --versions --regexp '\vharbor/harbor\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
app_versions=`helm search repo --versions --regexp '\vharbor/harbor\v' | awk '{print $3}' | grep -v VERSION`
helm pull harbor/harbor --version=${chart_version} -d charts/ --untar

cat <<'EOF' >"Kubefile"
FROM scratch
ENV NODE_IP "core.harbor.domain"
ENV NODE_PORT 30003
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i harbor charts/harbor -n harbor --create-namespace --set expose.type=nodePort,expose.tls.auto.commonName=$(NODE_IP),expose.nodePort.ports.https.nodePort=$(NODE_PORT),externalURL='https://$(NODE_IP):$(NODE_PORT)'"]
EOF
