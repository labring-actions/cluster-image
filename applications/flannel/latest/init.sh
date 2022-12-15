#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir opt/ manifests/
readonly cni=${cnilatest:-$(
  until curl -sL "https://api.github.com/repos/containernetworking/plugins/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}

curl -sL "https://github.com/containernetworking/plugins/releases/download/v$cni/cni-plugins-linux-$ARCH-v$cni.tgz" | tar xz -C opt/
wget -qP manifests/ https://raw.githubusercontent.com/flannel-io/flannel/${VERSION}/Documentation/kube-flannel.yml
sed -i s#10.244.0.0/16#100.64.0.0/10#g manifests/kube-flannel.yml
