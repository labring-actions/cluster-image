#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir manifests
wget -qP manifests https://raw.githubusercontent.com/cloudnativelabs/kube-router/${VERSION}/daemonset/kubeadm-kuberouter-all-features.yaml
sed -i "s#docker.io/cloudnativelabs/kube-router#docker.io/cloudnativelabs/kube-router:${VERSION}#g" manifests/kubeadm-kuberouter-all-features.yaml

mkdir opt
readonly cni_plugin_version=${cnilatest:-$(
  until curl -sL "https://api.github.com/repos/containernetworking/plugins/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}
curl -sL "https://github.com/containernetworking/plugins/releases/download/v${cni_plugin_version}/cni-plugins-linux-$ARCH-v${cni_plugin_version}.tgz" | tar xz -C opt
