#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir -p manifests/cloud-provider
docker run --network host --rm ghcr.io/kube-vip/kube-vip:${VERSION} \
  manifest pod \
  --interface _INTERFACE_ \
  --address _ADDRESS_ \
  --controlplane \
  --services \
  --arp \
  --leaderElection \
  --enableLoadBalancer >manifests/kube-vip.yaml.tmpl

sed -i "s#_INTERFACE_#{{ default \"\" .kube_vip_interface }}#g" manifests/kube-vip.yaml.tmpl
sed -i "s#_ADDRESS_#{{ default \"apiserver.cluster.local\" .kube_vip_address }}#g" manifests/kube-vip.yaml.tmpl

wget -q -N -P manifests/cloud-provider https://raw.githubusercontent.com/kube-vip/kube-vip-cloud-provider/main/manifest/kube-vip-cloud-controller.yaml

cat >manifests/cloud-provider/kube-vip-configmap.yaml.tmpl<<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kubevip
  namespace: kube-system
data:
{{- if .cidr_global }}
  cidr-global: {{ .cidr_global }}
{{- end }}
{{- if .range_global }}
  range-global: {{ .range_global }}
{{- end }}
EOF
