#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir -p charts
rm -rf charts/ceph-csi-rbd
helm repo add ceph-csi https://ceph.github.io/csi-charts
chart_version=`helm search repo --versions --regexp '\vceph-csi/ceph-csi-rbd\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull ceph-csi/ceph-csi-rbd --version=${chart_version} -d charts/ --untar
