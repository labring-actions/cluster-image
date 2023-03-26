#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

# download nerdctl
[ ! -d opt ] && mkdir opt
rm -rf opt/*
wget -qO- "https://github.com/containerd/nerdctl/releases/download/${VERSION}/nerdctl-${VERSION#v}-linux-${ARCH}.tar.gz" |
  tar -zx nerdctl
mv nerdctl opt/
chmod a+x opt/nerdctl

# download buildkit
buildkit_version=$(curl -s https://api.github.com/repos/moby/buildkit/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
wget -qO- https://github.com/moby/buildkit/releases/download/${buildkit_version}/buildkit-${buildkit_version}.linux-amd64.tar.gz |
  tar -zx  -C opt/ --strip=1
[ ! -d etc ] && mkdir etc
wget -N -qP etc/ https://raw.githubusercontent.com/moby/buildkit/${buildkit_version}/examples/systemd/system/buildkit.service
wget -N -qP etc/ https://raw.githubusercontent.com/moby/buildkit/${buildkit_version}/examples/systemd/system/buildkit.socket
