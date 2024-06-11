#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir -p manifests
wget "https://raw.githubusercontent.com/openebs/lvm-localpv/v${VERSION#*v}/deploy/lvm-operator.yaml" -O manifests/lvm-operator.yaml
