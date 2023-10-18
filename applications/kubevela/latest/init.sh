#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://kubevela.github.io/charts"
repo_name="kubevela"
chart_name="vela-core"
APP_VERSION=${VERSION#v}

function check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 is required, exiting the script"
    exit 1
  fi
}

function check_version(){
  rm -rf chart
  helm repo add ${repo_name} ${repo_url} --force-update 1>/dev/null

  # Check version number exists
  all_versions=$(helm search repo --versions --regexp "\v"${repo_name}/${chart_name}"\v" | awk '{print $3}' | grep -v VERSION)
  if ! echo "$all_versions" | grep -qw "${APP_VERSION}"; then
    echo "Error: Exit, the provided version ${VERSION} does not exist in helm repo, get available version with: helm search repo ${repo_name} --versions"
    exit 1
  fi
}

function init(){
  # Find the chart version through the app version
  chart_version=$(helm search repo --versions --regexp "\v"${repo_name}/${chart_name}"\v" |grep ${APP_VERSION} | awk '{print $2}' | sort -rn | head -n1)

  # Pull helm charts to local
  helm pull ${repo_name}/${chart_name} --version=${chart_version} -d chart --untar
  if [ $? -eq 0 ]; then
    echo "init success, next run sealos build"
  fi

  wget -qO- https://github.com/kubevela/kubevela/releases/download/${VERSION}/kubectl-vela-${VERSION}-linux-${ARCH}.tar.gz | tar -zx
  mv linux-${ARCH}/kubectl-vela opt/vela
  rm -rf linux-${ARCH}

  git clone https://github.com/kubevela/catalog --depth=1
  cp -r catalog/addons/velaux/ manifests/
  rm -rf catalog


  helm template chart/vela-core/ |grep "image: oamdev" | awk -F": " '{print "docker.io/"$2}' | sort -u > images/shim/velaImages
  VELAUX_VERSION=$(cat manifests/velaux/metadata.yaml  | grep version | cut -d " " -f2)
  cat <<EOF >>"images/shim/velaImages"
docker.io/oamdev/velaux:${VELAUX_VERSION}
EOF
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
