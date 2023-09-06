#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add gitea-charts https://dl.gitea.com/charts/
chart_version=$(helm search repo --versions --regexp '\vgitea-charts/gitea\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1)
helm pull gitea-charts/gitea --version=${chart_version} -d charts/ --untar
