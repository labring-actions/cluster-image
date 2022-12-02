#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

helm repo add prometheus-community --force-update https://prometheus-community.github.io/helm-charts
if [ $VERSION = "latest" ]
then helm pull prometheus-community/prometheus-adapter --untar -d charts/
else helm pull prometheus-community/prometheus-adapter --version=$VERSION --untar -d charts/
fi

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i prometheus-adapter charts/prometheus-adapter -n prometheus-adapter --create-namespace --set prometheus.url=http://kube-prometheus-stack-35-1-prometheus.prometheus.svc,prometheus.port=9090,prometheus.path=/"]
EOF

