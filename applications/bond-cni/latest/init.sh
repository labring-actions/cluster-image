#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf bond-cni opt
if [[ "$VERSION" == "latest" ]];then
  git clone https://github.com/k8snetworkplumbingwg/bond-cni.git --depth=1
else
  git clone https://github.com/k8snetworkplumbingwg/bond-cni.git -b "${VERSION}" --depth=1
fi

cd bond-cni
make build-bin
cd -
mkdir opt
cp -f bond-cni/bin/bond opt/
