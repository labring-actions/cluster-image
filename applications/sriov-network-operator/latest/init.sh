#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

app_version=${VERSION#v}
wget -q https://github.com/k8snetworkplumbingwg/sriov-network-operator/releases/download/v${app_version}/sriov-network-operator-${app_version}.tgz
mkdir -p charts
tar -xf sriov-network-operator-${app_version}.tgz -C charts/
mkdir -p images/shim 
cat charts/sriov-network-operator/values.yaml | grep "ghcr.io/k8snetworkplumbingwg" | awk '{print $2}' > images/shim/sriov-network-operator-Images
