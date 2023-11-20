#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://openebs.github.io/charts"
repo_name="openebs/openebs"
chart_name="openebs"
version_pattern="^v([0-9]+)\.([0-9]+)\.([0-9]+)$"

function check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 is required, exiting the script"
    exit 1
  fi
}

function check_version(){
  rm -rf charts
  helm repo add ${chart_name} ${repo_url} --force-update 1>/dev/null

  # Check version pattern
  if ! [[ $VERSION =~ $version_pattern ]]; then
    echo "version pattern not match, example of version format should be vx.x.x, exit"
    exit 1
  fi

  # Check version number exists
  all_versions=$(helm search repo --versions --regexp "\v"${repo_name}"\v" | awk '{print $3}' | grep -v VERSION)
  if ! echo "$all_versions" | grep -qw "${VERSION#v}"; then
    echo "Error: Exit, the provided version ${VERSION} does not exist in helm repo, get available version with: helm search repo ${repo_name} --versions"
    exit 1
  fi
}

function init(){
  # Find the chart version through the app version
  chart_version=$(helm search repo --versions --regexp "\v"${repo_name}"\v" |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1)

  # Pull helm charts to local
  helm pull ${repo_name} --version=${chart_version} -d charts --untar
  if [ $? -eq 0 ]; then
    echo "init success, next run sealos build"
  fi

  utils_tag=$(helm show values charts/openebs --jsonpath {.helper.imageTag})
  mkdir -p images/shim
  echo "docker.io/openebs/linux-utils:$utils_tag" >images/shim/openebsImages
}

function main() {
  if [ $# -ne 3 ]; then
    echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
    exit 1
  else
    check_command helm
    check_version
    init
  fi
}

main $@
