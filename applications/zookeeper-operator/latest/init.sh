#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts && mkdir -p charts
helm repo add pravega https://charts.pravega.io
chart_version=`helm search repo --versions --regexp '\vpravega/zookeeper-operator\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull pravega/zookeeper-operator --version=${chart_version} -d charts/ --untar
helm pull pravega/zookeeper --version=${chart_version} -d charts/ --untar
mkdir -p images/shim/

echo "pravega/zookeeper:${chart_version}" >  images/shim/images
