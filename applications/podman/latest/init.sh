#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf opt && mkdir opt
wget -qc https://github.com/mgoltzsche/podman-static/releases/download/${VERSION}/podman-linux-${ARCH}.tar.gz -O - | tar -xz -C opt/
mv opt/podman-linux-${ARCH} opt/podman-linux
