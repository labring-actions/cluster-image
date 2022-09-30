#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

manifests=(
)
charts=(
  "https://charts.rook.io/release=$NAME-ceph:$VERSION"
  "https://charts.rook.io/release=$NAME-ceph-cluster:$VERSION"
)
images=(
)
while IFS= read -r line; do images+=("$line"); done < <(wget -qO- "https://github.com/rook/rook/raw/${VERSION:-v1.10.2}/deploy/examples/images.txt")

if [[ $((${#manifests[@]} + ${#charts[@]} + ${#images[@]})) -ne 0 ]]; then
  cat <<EOF >"Kubefile"
FROM scratch
COPY registry registry
EOF
cp -af /tmp/scripts_apps/common* .
else
  echo "manifests,charts,images none at all."
  exit 1
fi

rm -f {manifests,charts,images}.sh
if [[ ${#manifests[@]} -ne 0 ]]; then
  ln -sf common.sh manifests.sh
  bash -e manifests.sh "${manifests[@]}" || true
fi
if [[ ${#charts[@]} -ne 0 ]]; then
  ln -sf common.sh charts.sh
  bash -e charts.sh "${charts[@]}" || true
fi
if [[ ${#images[@]} -ne 0 ]]; then
  ln -sf common.sh images.sh
  bash -e images.sh "${images[@]}"
fi
rm -f {manifests,charts,images}.sh

if [[ -s install_app ]]; then
  cat <<EOF >>"Kubefile"
COPY install_app .
CMD ["NAMESPACE=rook-ceph bash -e install_app $NAME-ceph=$VERSION","NAMESPACE=rook-ceph bash -e install_app $NAME-ceph-cluster=$VERSION --set operatorNamespace=rook-ceph"]
EOF
fi
