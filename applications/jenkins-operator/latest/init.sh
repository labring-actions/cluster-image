#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts && mkdir -p charts
wget -qO- https://github.com/jenkinsci/kubernetes-operator/archive/refs/tags/${VERSION}.tar.gz | \
tar -zx kubernetes-operator-${VERSION#v}/chart/jenkins-operator/ --strip=2
rm -rf jenkins-operator/jenkins-operator-*.tgz
mv jenkins-operator charts/
