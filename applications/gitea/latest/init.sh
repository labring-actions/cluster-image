#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add gitea https://dl.gitea.io/charts
chart_version=$(helm search repo --versions --regexp '\vgitea/gitea\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1)
helm pull gitea/gitea --version=${chart_version} -d charts/ --untar

yq e -i '.gitea.admin.password="gitea_admin"' charts/gitea/values.yaml
yq e -i '.ingress.enabled="true"' charts/gitea/values.yaml
yq e -i '.ingress.className="nginx"' charts/gitea/values.yaml
