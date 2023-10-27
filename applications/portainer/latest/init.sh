#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://portainer.github.io/k8s/"
repo_name="portainer"
chart_name="portainer"

function check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 is required, exiting the script"
    exit 1
  fi
}

function init(){
  rm -rf charts
  helm repo add ${repo_name} ${repo_url} --force-update 1>/dev/null
  # Find the chart version through the app version
  chart_version=$(helm search repo --versions --regexp "\v"${repo_name}/${chart_name}"\v" |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1)

  # Pull helm charts to local
  helm pull ${repo_name}/${chart_name} --version=${chart_version} -d charts --untar
  if [ $? -eq 0 ]; then
    echo "init success, next run sealos build"
  fi
}

function main() {
  if [ $# -ne 3 ]; then
    echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
    exit 1
  else
    check_command helm
    init
  fi
}

main $@
