#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

check_version(){
  # Check if the version number provided by the user exists
  github_repo="containernetworking/plugins"
  all_versions=$(curl -s "https://api.github.com/repos/${github_repo}/releases" | yq eval '.[].tag_name' -)
  if ! echo "$all_versions" | grep -qw "${VERSION}"; then
    echo -e "the provided version ${VERSION} does not exist in github release, support versions: \n${all_versions}"
    exit 1
  fi
}

function init(){
  curl -s -q --create-dirs -Lo opt/cni-plugins.tar.gz \
  "https://github.com/containernetworking/plugins/releases/download/$VERSION/$NAME-linux-$ARCH-$VERSION.tgz"
}

function main() {
  if [ $# -ne 3 ]; then
    echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
    exit 1
  else
    check_version
    init
  fi
}

main $@
