#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly BIN_DOWNLOAD=${4:-false }
if [ "${BIN_DOWNLOAD}" == "true" ]; then
  mkdir -p opt
  wget https://github.com/apecloud/kubeblocks/releases/download/v0.5.2/kbcli-linux-"${ARCH}"-v0.5.2.tar.gz -O kbcli.tar.gz
  tar -zxvf kbcli.tar.gz linux-"${ARCH}"/kbcli
  mv linux-"${ARCH}"/kbcli opt/kbcli
  chmod a+x opt/kbcli
  rm -rf linux-"${ARCH}" kbcli.tar.gz
  echo "download kbcli success"
fi
helm repo add kubeblocks https://apecloud.github.io/helm-charts
mkdir -p charts
#chart_version=`helm search repo --versions --regexp '\vkubeblocks/kubeblocks\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
#helm pull kubeblocks/kubeblocks --version=${chart_version} -d charts/
helm search repo kubeblocks | awk 'NR>1{print $1}'|xargs -I {} helm fetch {} -d charts/
