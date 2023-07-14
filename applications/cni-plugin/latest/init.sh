#!/bin/bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

sed -i "s#docker.io/labring/docker-cni-plugins:.*#docker.io/labring/docker-cni-plugins:${VERSION}#g" manifests/cni-plugin.yaml


