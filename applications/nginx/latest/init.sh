#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm pull bitnami/nginx --untar -d charts

cat <<EOF >>"Kubefile"
FROM scratch
COPY . .
CMD ["helm upgrade -i nginx charts/nginx -n nginx --create-namespace --set service.type=NodePort"]
EOF
