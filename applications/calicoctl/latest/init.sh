#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

check_version(){
  # Check if the version number provided by the user exists
  local github_repo="projectcalico/calico"
  local all_versions=$(curl -s "https://api.github.com/repos/${github_repo}/releases" | yq eval '.[].tag_name' -)
  if ! echo "$all_versions" | grep -qw "${VERSION}"; then
    echo -e "the provided version ${VERSION} does not exist in github release, support versions: \n${all_versions}"
    exit 1
  fi
}

init(){
  local binary_url="https://github.com/projectcalico/calico/releases/download/${VERSION}/calicoctl-linux-${ARCH}"
  local binary_name="calicoctl"
  curl -s -q --create-dirs -Lo opt/${binary_name} ${binary_url}
  chmod +x opt/${binary_name}
}

main() {
  if [ $# -ne 3 ]; then
    echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
    exit 1
  else
    check_version
    init
  fi
}

main $@
