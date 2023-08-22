#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add --force-update grafana https://grafana.github.io/helm-charts
chart_version=$(helm search repo --versions --regexp '\vgrafana/loki\v' | grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1)

rm -rf charts/ images/shim/ && mkdir -p images/shim/
helm pull grafana/loki --version=${chart_version} -d charts/ --untar

# parse minio image
cat >charts/loki.values.yaml<<EOF
minio:
  enabled: true
EOF

# parse prometheus-config-reloader image
grafana_agent_operator_version=$(cat charts/loki/charts/grafana-agent-operator/Chart.yaml | grep appVersion | awk '{print $2}')
grafana_agent_url=https://raw.githubusercontent.com/grafana/agent/v${grafana_agent_operator_version}/pkg/operator/resources_pod_template.go
prometheus_config_reloader=$(curl -v --silent ${grafana_agent_url} 2>&1 | grep prometheus-config-reloader | awk -F "[\"\"]" '{print $2}')
echo ${prometheus_config_reloader} > images/shim/loki-images.txt
