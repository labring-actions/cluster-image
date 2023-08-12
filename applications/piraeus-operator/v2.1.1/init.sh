#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

function kubectl-linstor(){
  rm -rf opt/ && mkdir -p opt/
  readonly linstor_version=${linstor_version:-$(
  until curl -sL "https://api.github.com/repos/piraeusdatastore/kubectl-linstor/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
  )}
  wget -qO- https://github.com/piraeusdatastore/kubectl-linstor/releases/download/v${linstor_version}/kubectl-linstor-v${linstor_version}-linux-${ARCH}.tar.gz | tar -zx kubectl-linstor
  mv kubectl-linstor opt/
}

function init(){
  rm -rf chart
  wget -qO- https://github.com/piraeusdatastore/piraeus-operator/archive/refs/tags/${VERSION}.tar.gz | tar -xz
  mv piraeus-operator-${VERSION#v}/charts/ ./chart
  rm -rf piraeus-operator-${VERSION#v}
}

kubectl-linstor
init
