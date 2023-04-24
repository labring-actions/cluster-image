#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly NAME=${1:-$(basename "${PWD%/*}")}
export readonly VERSION=${2:-$(basename "$PWD")}

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
chart_version=`helm search repo --versions --regexp '\vkubernetes-dashboard/kubernetes-dashboard\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`

rm -rf charts && mkdir -p charts
helm pull kubernetes-dashboard/kubernetes-dashboard --version=${chart_version} -d charts/ --untar
yq e -i '.service.type="NodePort"' charts/kubernetes-dashboard/values.yaml
