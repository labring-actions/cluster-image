#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://seaweedfs.github.io/seaweedfs/helm"
repo_name="seaweedfs/seaweedfs"
chart_name="seaweedfs"

helm repo add ${chart_name} $repo_url
chart_version=$(helm search repo --versions --regexp "\v"${repo_name}"\v" |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1)
helm pull ${repo_name} --version=${chart_version} -d charts --untar
#yq e -i '.service.type="NodePort"' charts/seaweedfs/values.yaml
