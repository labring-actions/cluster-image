#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

VERSION=${VERSION#v}

file_url=https://github.com/kubernetes/autoscaler/archive/refs/tags/vertical-pod-autoscaler-${VERSION}.tar.gz
wget -q ${file_url}

rm -rf autoscaler
tar -xzf vertical-pod-autoscaler-${VERSION}.tar.gz autoscaler-vertical-pod-autoscaler-${VERSION}/vertical-pod-autoscaler
mv autoscaler-vertical-pod-autoscaler-${VERSION} autoscaler
rm -f vertical-pod-autoscaler-${VERSION}.tar.gz

mkdir -p images/shim
deploy_path='./autoscaler/vertical-pod-autoscaler/deploy'
#example_path='./autoscaler/vertical-pod-autoscaler/examples'
grep -rn 'image: ' ${deploy_path} | awk -F" " '{print $3}' | sort -u > images/shim/autoscaler-vertical-pod-autoscaler-images.txt
#grep -rn 'image: ' ${example_path} | awk -F" " '{print $3}' | sort -u >> images/shim/autoscaler-vertical-pod-autoscaler-images.txt
