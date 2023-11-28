#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

export VERSION=${VERSION#v}

init_dir() {
    ETC_DIR="./etc"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifest"

    rm -rf "${ETC_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
    mkdir -p "${IMAGES_DIR}"
}

command_exists() {
    local command="$1"
    if ! command -v "$command" &> /dev/null; then
        echo "$command does not exist"
        exit 1
    fi
}

download_spinnaker_files(){
    local proxy_enabled=true
    if [[ "${proxy_enabled}" == "true" ]]; then
        docker_opts="--env http_proxy=http://192.168.72.1:7890 --env https_proxy=http://192.168.72.1:7890"
    fi
    docker rm -f gloud-cli &>/dev/null || true
    docker run -d --name gloud-cli -w /workspace -e spinnaker_version=${VERSION} ${docker_opts} \
        docker.io/google/cloud-sdk:alpine sleep infinity

    docker cp scripts/get_bom.sh gloud-cli:/workspace
    docker exec gloud-cli bash get_bom.sh
    docker cp gloud-cli:/workspace/etc .
    docker cp gloud-cli:/workspace/images .
}

generate_version() {
    DEPLOYMENT_FILE="manifests/halyard_deployment.yaml.tmpl"
    sed -i "/name: spinnaker_version/{n;s/value:.*/value: \"$VERSION\"/}" $DEPLOYMENT_FILE
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        command_exists docker
        command_exists yq
        download_spinnaker_files
        generate_version
    fi
}

main $@
