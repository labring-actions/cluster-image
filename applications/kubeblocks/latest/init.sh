#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly BIN_DOWNLOAD=${4:-"true"}

if [ "${BIN_DOWNLOAD}" == "true" ]; then
  mkdir -p opt
  wget https://github.com/apecloud/kbcli/releases/download/"${VERSION}"/kbcli-linux-"${ARCH}"-"${VERSION}".tar.gz -O kbcli.tar.gz
  tar -zxvf kbcli.tar.gz linux-"${ARCH}"/kbcli
  mv linux-"${ARCH}"/kbcli opt/kbcli
  chmod a+x opt/kbcli
  rm -rf linux-"${ARCH}" kbcli.tar.gz
  echo "download kbcli success"
fi

mkdir charts

repo_url="https://github.com/apecloud/helm-charts/releases/download"
charts=("kubeblocks")
for chart in "${charts[@]}"; do
  chart_version=${VERSION#v}
  helm fetch -d charts --untar "$repo_url"/"${chart}"-"${chart_version}"/"${chart}"-"${chart_version}".tgz
  rm -rf charts/"${chart}"-"${chart_version}".tgz
done

# add extra images
mkdir -p images/shim
echo "apecloud/kubeblocks-charts:${VERSION#v}" >images/shim/kubeblocksImages
