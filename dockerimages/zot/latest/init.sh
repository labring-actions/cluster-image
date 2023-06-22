#!/bin/bash

set -e

readonly ARCH=${1:-amd64}
readonly NAME=${2:-zot}
readonly VERSION=${3:-v2.0.0-rc4}
cat <<EOF > Dockerfile
FROM ghcr.io/project-zot/zot-linux-${ARCH}:${VERSION}
EOF
