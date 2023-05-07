#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

helm repo add emberstack https://emberstack.github.io/helm-charts
if [ $VERSION = "latest" ]
then helm pull emberstack/reflector --untar -d charts/
else helm pull emberstack/reflector --version=$VERSION --untar -d charts/
fi
#https://docs.solo.io/gloo-edge/latest/reference/helm_chart_values/open_source_helm_chart_values/
cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i reflector charts/reflector -n reflector-system --create-namespace"]
EOF
