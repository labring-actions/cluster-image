#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add apisix --force-update https://charts.apiseven.com
chart_version=`helm search repo --versions --regexp '\vapisix/apisix\v' |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1`
app_versions=`helm search repo --versions --regexp '\vapisix/apisix\v' | awk '{print $3}' | grep -v VERSION`
echo "support app_versions: $app_versions"

rm -rf charts/ manifests/
mkdir -p charts/ manifests/
helm pull apisix/apisix --version=${chart_version} -d charts/ --untar
helm template apisix charts/apisix ingress-controller.enabled=true,dashboard.enabled=true > manifests/apisix-template.yaml

cat <<'EOF' >"Kubefile"
FROM scratch
ENV SERVICE_TYPE "NodePort"
ENV GATEWAY_TLS "false"
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i apisix charts/apisix -n apisix --create-namespace --set ingress-controller.enabled=true,dashboard.enabled=true,ingress-controller.config.apisix.serviceNamespace=ingress-apisix,gateway.type=$(SERVICE_TYPE),dashboard.service.type=$(SERVICE_TYPE),gateway.tls.enabled=$(GATEWAY_TLS)"]
EOF
