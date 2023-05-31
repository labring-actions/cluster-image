#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

declare -r ARCH=${1:-amd64}
declare -r NAME=${2:-$(basename "${PWD%/*}")}
declare -r VERSION=${3:-$(basename "$PWD")}

mkdir -p manifests
cd manifests && {
  wget "https://github.com/cert-manager/cert-manager/releases/download/$VERSION/cert-manager.yaml"
  cd -
}
