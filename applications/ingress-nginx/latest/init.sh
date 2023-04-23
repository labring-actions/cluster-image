#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
chart_version=$(helm search repo --versions --regexp '\vingress-nginx/ingress-nginx\v' | grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1)
helm pull ingress-nginx/ingress-nginx --version=${chart_version} -d charts --untar
