#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir manifests
wget -qP manifests https://raw.githubusercontent.com/cloudnativelabs/kube-router/${VERSION}/daemonset/kubeadm-kuberouter-all-features.yaml
sed -i "s#docker.io/cloudnativelabs/kube-router#docker.io/cloudnativelabs/kube-router:${VERSION}#g" manifests/kubeadm-kuberouter-all-features.yaml
