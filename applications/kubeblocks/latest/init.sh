#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly BIN_DOWNLOAD=${4:-"true"}
export readonly REDUCE_VERSION=${5:-"false"}

if [[ -z "${BIN_DOWNLOAD}" || "${BIN_DOWNLOAD}" == "true" ]]; then
    mkdir -p opt
    wget https://github.com/apecloud/kubeblocks/releases/download/"${VERSION}"/kbcli-linux-"${ARCH}"-"${VERSION}".tar.gz -O kbcli.tar.gz
    tar -zxvf kbcli.tar.gz linux-"${ARCH}"/kbcli
    mv linux-"${ARCH}"/kbcli opt/kbcli
    chmod a+x opt/kbcli
    rm -rf linux-"${ARCH}" kbcli.tar.gz
    echo "download kbcli success"
fi

mkdir charts

repo_url="https://github.com/apecloud/helm-charts/releases/download"
charts=("kubeblocks" "apecloud-mysql" "mongodb" "postgresql" "redis" "kafka" "qdrant" "clickhouse")
if [[ "${VERSION}" == "v0.6."* ]]; then
    charts=("kubeblocks" "apecloud-mysql" "mongodb" "postgresql" "redis" "kafka")
fi
for chart in "${charts[@]}"; do
    helm fetch -d charts --untar "$repo_url"/"${chart}"-"${VERSION#v}"/"${chart}"-"${VERSION#v}".tgz
    if [[ "$REDUCE_VERSION" == "true" ]]; then
        case $chart in
            mongodb)
                yq e -i '.enabledClusterVersions=[ "mongodb-5.0", "mongodb-6.0" ]' charts/${chart}/values.yaml
            ;;
            postgresql)
                yq e -i '.enabledClusterVersions=[ "postgresql-14.7.2", "postgresql-12.15.0" ]' charts/${chart}/values.yaml
            ;;
        esac

    fi
    rm -rf charts/"${chart}"-"${VERSION#v}".tgz
done

# add extra images
mkdir -p images/shim
echo "apecloud/kubeblocks-charts:${VERSION#v}" >images/shim/kubeblocksImages
