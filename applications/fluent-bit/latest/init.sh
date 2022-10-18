#!/bin/bash

#set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add fluent https://fluent.github.io/helm-charts

rm -rf charts
mkdir -p charts
helm pull fluent/fluent-bit --version=${VERSION} --untar -d charts

cat <<EOF >"Kubefile"
FROM scratch
COPY . .
CMD ["helm upgrade -i fluent-bit charts/fluent-bit -n elastic --create-namespace"]
EOF
