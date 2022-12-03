#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

VERSION=`echo ${VERSION} | sed 's/.//'`
chart_version=`helm search repo --versions --regexp '\vingress-nginx/ingress-nginx\v' |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1`

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm pull ingress-nginx/ingress-nginx --version=${chart_version} -d charts/ --untar

cat <<'EOF' >"Kubefile"
FROM scratch
ENV SERVICE_TYPE "LoadBalancer"
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i ingress-nginx charts/ingress-nginx -n ingress-nginx --create-namespace --set controller.service.type=$(SERVICE_TYPE)"]
EOF
