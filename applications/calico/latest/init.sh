#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

declare -r ARCH=${1:-amd64}
declare -r NAME=${2:-$(basename "${PWD%/*}")}

inVERSION=${3:-$(basename "$PWD")}

if [[ $inVERSION =~ ^v[.0-9]+$ ]]; then
  declare -r VERSION=$inVERSION
else
  declare -r VERSION="v$inVERSION"
  declare -r XY_LATEST=true
  sed -i 's~ tigera-operator ~ kube-system ~g' Kubefile
fi

mkdir -p charts
cd charts && {
  # https://projectcalico.docs.tigera.io/release-notes/
  wget -qO- "https://github.com/projectcalico/$NAME/releases/download/$VERSION/tigera-operator-$VERSION.tgz" | tar -zx
  mv tigera-operator "$NAME"
  find . -type f -name "*.tmpl" -exec mv -v {} {}.bak \;
  yq e -n '.installation.calicoNetwork.nodeAddressAutodetectionV4.interface="bond.*|eth.*|en.*"' >"calico.values.yaml"

  tigeraOperator_default=$(yq .tigeraOperator.version "$NAME/values.yaml")
  if [[ "$XY_LATEST" == true ]]; then
    tigeraOperator_version=$(until git ls-remote --refs --sort="version:refname" --tags "https://github.com/tigera/operator.git" | cut -d/ -f3- | grep -E "^v[0-9.]+$"; do sleep 3; done | grep "${tigeraOperator_default%.*}" | tail -n 1)
  else
    tigeraOperator_version=$tigeraOperator_default
  fi
  tigeraOperator=$tigeraOperator_version yq '.tigeraOperator.version=strenv(tigeraOperator)' --inplace "$NAME/values.yaml"
  for file in common calico; do
    wget -qO- "https://github.com/tigera/operator/raw/$tigeraOperator_version/pkg/components/$file.go" | grep -B1 Image: | sed "s/version.VERSION/\"$tigeraOperator_version\"/g" |
      awk -F\" '/[IV]+/{str[NR]=$(NF-1);if(str[NR]!~/v[0-9.]+/)if(str[NR]~/calico\/.+/){printf("docker.io/%s:%s\n",$(NF-1),str[NR-1])}else{printf("quay.io/%s:%s\n",$(NF-1),str[NR-1])}}'
  done |
    grep -v windows-upgrade: |
    grep -v fips |
    sort >"$NAME/Images"
  cd -
}

if [[ -s "charts/$NAME/Images" ]]; then
  mkdir -p images/shim
  cp "charts/$NAME/Images" "images/shim/${NAME}Images"
fi
