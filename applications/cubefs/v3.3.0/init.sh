#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

command_check() {
    local command="$1"
    {
      $command >/dev/null 2>&1
    } || {
      echo "$1 is failed or does not exist, exiting the script"
      exit 1
    }
}

init_dir() {
    OPT_DIR="./opt"
    IMAGES_DIR="./images"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
    mkdir -p "${CHARTS_DIR}"
}

download_charts() {
    git clone https://github.com/cubefs/cubefs-helm.git --depth=1
    cp -r cubefs-helm/cubefs/ charts/
    rm -rf cubefs-helm
    cat >charts/cubefs.values.yaml<<EOF
image:
  server: cubefs/cfs-server:v3.3.0
  client: cubefs/cfs-client:v3.3.0
metanode:
  metanode:
    total_mem: 4294967296
  resources:
    enabled: false
EOF
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        command_check "git --help"
        init_dir
        download_charts
    fi
}

main $@
