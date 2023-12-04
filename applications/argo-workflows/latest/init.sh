#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://argoproj.github.io/argo-helm"
repo_name="argo/argo-workflows"
chart_name="argo"

helm repo add ${chart_name} ${repo_url} --force-update

function version_check(){
  all_versions=$(helm search repo --versions --regexp "\v"${repo_name}"\v" | awk '{print $3}' | grep -v VERSION)

  # Check if the provided version number exists in all versions
  if ! echo "$all_versions" | grep -qw "${VERSION}"; then
    echo "Error: The provided version ${VERSION} does not exist in Helm Chart Repo $repo_name. Available versions are:"
    echo "$all_versions"
    exit 1
  fi
}

function init(){
  rm -rf images/shim && mkdir -p images/shim
  echo "quay.io/argoproj/argoexec:${VERSION}" > images/shim/argoImage
  echo "argoproj/argosay:v2" >> images/shim/argoImage
  echo "docker/whalesay" >> images/shim/argoImage
  rm -rf charts opt && mkdir -p charts opt
  chart_version=$(helm search repo --versions --regexp "\v"${repo_name}"\v" |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1)
  helm pull ${repo_name} --version=${chart_version} -d charts --untar
  wget -qO- https://github.com/argoproj/argo-workflows/releases/download/${VERSION}/argo-linux-${ARCH}.gz | gunzip -c > opt/argo
  chmod +x opt/argo
}

version_check
init
