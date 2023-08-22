#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add --force-update grafana https://grafana.github.io/helm-charts
chart_version=$(helm search repo --versions --regexp '\vgrafana/promtail\v' | grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1)
rm -rf charts/
helm pull grafana/promtail --version=${chart_version} -d charts/ --untar
