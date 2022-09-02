#!/bin/bash

set -e

readonly ARCH=${1:-amd64}
readonly NAME=${2:-cilium}
readonly VERSION=${3:-v1.12.1}

mkdir -p charts
cd charts && {
  wget -qO- "https://github.com/$NAME/charts/raw/master/$NAME-${VERSION#*v}.tgz" | tar -zx
  find . -type f -name "*.tmpl" -exec mv -v {} {}.bak \;
  sed -i 's#useDigest: true#useDigest: false#g;/sidecarImageRegex/d' "$NAME/values.yaml"
  {
    # https://github.com/cilium/cilium/blob/master/operator/Makefile
    yq '.operator.image.override=.operator.image.repository +":"+ .operator.image.tag' --inplace "$NAME/values.yaml"
    sed -i 's#- cilium-operator-.+#- cilium-operator#g' -E "$NAME/templates/cilium-operator/deployment.yaml"
  }
  {
    # get Images
    yq '... style=""' "$NAME/values.yaml" |
      grep -E "(repository|tag):" | awk '{print $NF}' | awk -F@ '{print $1}' |
      sed 's#^#    #g' | sed -E 's#    (.+)/(.+)#- \1/\2:#g' |
      yq ".[]" | sed 's# ##g' >"$NAME/Images"
  }
  cd -
}

if [[ -s "charts/$NAME/Images" ]]; then
  mkdir -p images/shim
  cp "charts/$NAME/Images" "images/shim/${NAME}Images"
fi

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
