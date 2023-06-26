#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly BIN_DOWNLOAD=${4:-"true" }
if [ "${BIN_DOWNLOAD}" == "true" ]; then
  mkdir -p opt
  wget https://github.com/apecloud/kubeblocks/releases/download/v0.5.2/kbcli-linux-"${ARCH}"-v0.5.2.tar.gz -O kbcli.tar.gz
  tar -zxvf kbcli.tar.gz linux-"${ARCH}"/kbcli
  mv linux-"${ARCH}"/kbcli opt/kbcli
  chmod a+x opt/kbcli
  rm -rf linux-"${ARCH}" kbcli.tar.gz
  echo "download kbcli success"
fi
mkdir -p charts

# 需要下载到的目标目录
target_dir="charts"
# 文件名，这里以 `urls.txt` 为例
file="chartlist"
# 使用 `while` 循环和 `read` 命令来读取文件中的每一行
while IFS= read -r line
do
    # 使用 `wget` 或 `curl` 命令来下载文件
    # 这里以 `wget` 为例
    wget -P $target_dir "$line"
done < "$file"

rm -rf charts/aws-load-balancer*
