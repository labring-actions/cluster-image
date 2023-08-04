#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://charts.bitnami.com/bitnami"
repo_name="bitnami/nginx"
chart_name="bitnami"

helm repo add ${chart_name} ${repo_url} --force-update

function version_check(){
  all_versions=$(helm search repo --versions --regexp "\v"${repo_name}"\v" | awk '{print $3}' | grep -v VERSION)

  # Check if the provided version number exists in all versions
  if ! echo "$all_versions" | grep -qw "${VERSION#v}"; then
    echo "Error: The provided version ${VERSION} does not exist in Helm Chart Repo $repo_name. Available versions are:"
    echo "$all_versions"
    exit 1
  fi
}

function init(){
  rm -rf charts && mkdir -p charts
  helm repo add ${chart_name} ${repo_url}
  chart_version=$(helm search repo --versions --regexp "\v"${repo_name}"\v" |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1)
  helm pull ${repo_name} --version=${chart_version} -d charts --untar
  yq e -i '.service.type="NodePort"' charts/nginx/values.yaml
}

version_check
init
