#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly BIN_DOWNLOAD=${4:-"true"}

if [ "${BIN_DOWNLOAD}" == "true" ]; then
  mkdir -p opt
  wget https://github.com/apecloud/kubeblocks/releases/download/"${VERSION}"/kbcli-linux-"${ARCH}"-"${VERSION}".tar.gz -O kbcli.tar.gz
  tar -zxvf kbcli.tar.gz linux-"${ARCH}"/kbcli
  mv linux-"${ARCH}"/kbcli opt/kbcli
  chmod a+x opt/kbcli
  rm -rf linux-"${ARCH}" kbcli.tar.gz
  echo "download kbcli success"
fi

mkdir -p charts
helm fetch -d charts https://jihulab.com/api/v4/projects/85949/packages/helm/stable/charts/kubeblocks-${VERSION#v}.tgz

cat > kb.sh <<EOF
#!/bin/bash
cp -rf opt/kbcli /usr/local/bin/
helm upgrade -i kubeblocks charts/kubeblocks-${VERSION#v}.tgz --set snapshot-controller.enabled=false --insecure-skip-tls-verify -n kb-system --create-namespace
EOF

chmod a+x kb.sh