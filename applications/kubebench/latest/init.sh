#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
mkdir charts

repo_url="https://github.com/apecloud/helm-charts/releases/download"
charts=( "kubebench")
for chart in "${charts[@]}"; do
    helm fetch -d charts --untar "$repo_url"/"${chart}"-"${VERSION#v}"/"${chart}"-"${VERSION#v}".tgz
    rm -rf charts/"${chart}"-"${VERSION#v}".tgz
done

# add extra images
mkdir -p images/shim
echo "registry.cn-hangzhou.aliyuncs.com/apecloud/customsuites:latest" >images/shim/kubebenchImages
echo "registry.cn-hangzhou.aliyuncs.com/apecloud/benchmarksql:latest" >>images/shim/kubebenchImages
#echo "registry.cn-hangzhou.aliyuncs.com/apecloud/spilo:14.8.0" >>images/shim/kubebenchImages
#echo "registry.cn-hangzhou.aliyuncs.com/apecloud/go-ycsb:latest" >>images/shim/kubebenchImages
#echo "registry.cn-hangzhou.aliyuncs.com/apecloud/fio:latest" >>images/shim/kubebenchImages
#echo "registry.cn-hangzhou.aliyuncs.com/apecloud/redis:7.0.5" >>images/shim/kubebenchImages
#echo "registry.cn-hangzhou.aliyuncs.com/apecloud/kubebench:0.0.6" >>images/shim/kubebenchImages
