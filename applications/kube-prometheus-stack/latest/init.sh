#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
chart_version=`helm search repo --versions --regexp '\vprometheus-community/kube-prometheus-stack\v' | grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1`
rm -rf charts/ && mkdir -p charts/
helm pull prometheus-community/kube-prometheus-stack --version=${chart_version} -d charts/ --untar
mkdir -p images/shim

thanos_image_tag=$(cat charts/kube-prometheus-stack/values.yaml | yq .prometheusOperator.thanosImage.tag)
echo "quay.io/prometheus-operator/prometheus-config-reloader:${VERSION}" > images/shim/kube-prometheus-stackImages
echo "quay.io/thanos/thanos:${thanos_image_tag}" >> images/shim/kube-prometheus-stackImages

# custome values.yaml
cat >charts/kube-prometheus-stack.values.yaml<<EOF
prometheus:
  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: "false"
grafana:
  service:
    type: "NodePort"
EOF
