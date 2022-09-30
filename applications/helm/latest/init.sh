#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf opt
wget -qO- "https://get.helm.sh/$NAME-$VERSION-linux-$ARCH.tar.gz" |
  tar -zx "linux-$ARCH/helm"
mv "linux-$ARCH" opt
chmod a+x opt/helm

cat <<EOF >>"Kubefile"
FROM scratch
COPY opt opt
CMD ["cp -a opt/helm /usr/bin/"]
EOF
