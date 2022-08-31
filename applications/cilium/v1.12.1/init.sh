#!/bin/bash

set -e

readonly ARCH=${1:-amd64}
readonly NAME=${2:-cilium}
readonly VERSION=${3:-v1.12.1}

mkdir -p charts
cd charts && {
  wget -qO- "https://github.com/$NAME/charts/raw/master/$NAME-${VERSION#*v}.tgz" | tar -zx
  find . -type f -name "*.tmpl" -exec mv -v {} {}.bak \;
  sed -i 's#useDigest: true#useDigest: false#g' "$NAME/values.yaml"
  cd -
}

mkdir -p opt
cd opt && {
  wget -qO- "https://github.com/$NAME/$NAME-cli/releases/download/v$(
    curl --silent "https://api.github.com/repos/$NAME/$NAME-cli/releases/latest" |
      grep tarball_url |
      awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' |
      cut -dv -f2
  )/cilium-linux-$ARCH.tar.gz" | tar -zx
  wget -qO- "https://github.com/$NAME/hubble/releases/download/v$(
    curl --silent "https://api.github.com/repos/cilium/hubble/releases/latest" |
      grep tarball_url |
      awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' |
      cut -dv -f2
  )/hubble-linux-$ARCH.tar.gz" | tar -zx
  cd -
}
