#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add grafana https://grafana.github.io/loki/charts
chart_version=`helm search repo --versions --regexp '\vgrafana/loki-stack\v' |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1`
rm -rf charts/
helm pull grafana/loki-stack --version=${chart_version} -d charts/ --untar

cat >charts/loki-stack.values.yaml<<EOF 
promtail:
  enabled: false
fluent-bit:
  enabled: true
grafana:
  enabled: true
EOF
