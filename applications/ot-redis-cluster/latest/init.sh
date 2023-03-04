#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
chart_version=`helm search repo --versions --regexp '\vot-helm/redis-operator\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull ot-helm/redis-operator --version=${chart_version} -d charts/ --untar
helm pull ot-helm/redis-cluster --version=${chart_version} -d charts/ --untar
