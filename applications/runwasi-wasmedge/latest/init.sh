#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-latest}

cat <<EOF >>"Kubefile"
FROM ghcr.io/second-state/runwasi-wasmedge-plugin:allinone.${VERSION}
COPY install.sh install.sh
CMD ["bash install.sh"]
EOF
