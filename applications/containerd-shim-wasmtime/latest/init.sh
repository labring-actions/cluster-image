#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-latest}

if [ "$ARCH" == "arm64" ]; then
    ARCH="aarch64"
fi
if [ "$ARCH" == "amd64" ]; then
    ARCH="x86_64"
fi
mkdir -p ${NAME}/bin
wget -O runwasi.tar.gz https://github.com/containerd/runwasi/releases/download/${NAME}/${VERSION}/${NAME}-${ARCH}.tar.gz
tar -zxvf runwasi.tar.gz -C ${NAME}/bin


cat <<EOF >>"Kubefile"
FROM scratch
COPY ${NAME} ${NAME}/${VERSION}
LABEL sealos.io.type="patch"
COPY install.sh ${NAME}/${VERSION}/install.sh
CMD ["bash ${NAME}/install.sh ${NAME}/${VERSION}"]
EOF
