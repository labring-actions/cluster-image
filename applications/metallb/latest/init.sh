#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts && mkdir charts
helm repo add --force-update metallb https://metallb.github.io/metallb
helm pull metallb/metallb --version=${VERSION#v} -d charts/ --untar

mkdir -p manifests
cat >manifests/IPAddressPool.yaml.tmpl<<EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: {{ default "metallb-system" .NAMESPACE }}
spec:
  addresses:
  - {{ .addresses }}
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2
  namespace: {{ default "metallb-system" .NAMESPACE }}
EOF
