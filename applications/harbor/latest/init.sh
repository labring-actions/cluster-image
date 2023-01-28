#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

chart_version=`helm search repo --versions --regexp '\vharbor/harbor\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm repo add harbor https://helm.goharbor.io
helm pull harbor/harbor --version=${chart_version} -d charts/ --untar
yq e -i '.expose.ingress.className="nginx"' charts/harbor/values.yaml
