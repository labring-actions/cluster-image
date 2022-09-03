#!/bin/bash

set -e

readonly ARCH=${1:-amd64}
readonly NAME=${2:-calico}
readonly VERSION=${3:-v3.24.1}

mkdir -p charts
cd charts && {
  # https://projectcalico.docs.tigera.io/release-notes/
  wget -qO- "https://github.com/projectcalico/$NAME/releases/download/$VERSION/tigera-operator-$VERSION.tgz" | tar -zx
  mv tigera-operator "$NAME"
  find . -type f -name "*.tmpl" -exec mv -v {} {}.bak \;
  yq '.installation.calicoNetwork.nodeAddressAutodetectionV4.interface="eth.*|en.*"' --inplace "$NAME/values.yaml"
  cat <<EOF >"$NAME/Images"
docker.io/calico/apiserver:$VERSION
docker.io/calico/cni:$VERSION
docker.io/calico/csi:$VERSION
docker.io/calico/ctl:$VERSION
docker.io/calico/dikastes:$VERSION
docker.io/calico/kube-controllers:$VERSION
docker.io/calico/node-driver-registrar:$VERSION
docker.io/calico/node:$VERSION
docker.io/calico/pod2daemon-flexvol:$VERSION
docker.io/calico/typha:$VERSION
EOF
  cd -
}

if [[ -s "charts/$NAME/Images" ]]; then
  mkdir -p images/shim
  cp "charts/$NAME/Images" "images/shim/${NAME}Images"
fi
