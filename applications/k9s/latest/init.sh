#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir opt
wget -qO- "https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_${ARCH}.tar.gz" | tar -xz -C opt
chmod a+x opt/k9s
