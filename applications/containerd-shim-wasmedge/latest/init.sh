#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

readonly NAME=${2:-$(basename "${PWD%/*}")}
readonly VERSION=${3:-latest}
case ${1:-amd64} in
arm64)
  readonly ARCH="aarch64"
  ;;
amd64)
  readonly ARCH="x86_64"
  ;;
esac

mkdir -p "$NAME/bin"
wget -qO- "https://github.com/containerd/runwasi/releases/download/$NAME/$VERSION/$NAME-$ARCH.tar.gz" | tar -C "$NAME/bin" -xzv

cat <<EOF >>"Kubefile"
FROM scratch
LABEL sealos.io.type="patch"
COPY $NAME $NAME/$VERSION
COPY install.sh $NAME/$VERSION/install.sh
CMD ["bash $NAME/$VERSION/install.sh"]
EOF
