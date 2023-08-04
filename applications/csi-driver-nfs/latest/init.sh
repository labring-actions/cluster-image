#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
repo_name="csi-driver-nfs/csi-driver-nfs"
chart_name="csi-driver-nfs"

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
  rm -rf charts && mkdir -p charts
  helm repo add ${chart_name} ${repo_url}
  helm pull ${repo_name} --version=${VERSION} -d charts --untar
}

version_check
init
