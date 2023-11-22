#!/usr/bin/env bash

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

download_spinnaker_boms(){
    docker rm -f yq &>/dev/null || true
    docker create --name yq -v yq:/usr/bin/yq docker.io/mikefarah/yq:4.40.2

    local proxy_enabled=false
    if [[ "${proxy_enabled}" == "true" ]]; then
        docker_opts="--env HTTP_PROXY='http://192.168.10.1:7890' --env HTTP_PROXY='http://192.168.10.1:7890'"
    fi
    docker rm -f gloud-cli &>/dev/null || true
    docker run -d --name gloud-cli -v ./etc:/workspace -w /workspace -v yq:/usr/local/bin -e spinnaker_version=${VERSION} \
      ${docker_opts} \
      docker.io/google/cloud-sdk:alpine sleep infinity

    docker cp scripts/get_bom.sh gloud-cli:/workspace
    docker exec -it gloud-cli bash get_bom.sh
    docker exec -it gloud-cli rm -f get_bom.sh
}

generate_spinnaker_images() {
    export spinnaker_version=${VERSION}
    export halyard_image="us-docker.pkg.dev/spinnaker-community/docker/halyard:stable"
    export spinnaker_dockerRegistry="us-docker.pkg.dev/spinnaker-community/docker/"
    export dockerhub_dockerRegistry="docker.io/library/"
    export spinnaker_bom="etc/halconfig/bom/${spinnaker_version}.yml"

    yq -r '.services | to_entries | .[] | env(spinnaker_dockerRegistry) + .key + ":" + .value.version' ${spinnaker_bom} > ${IMAGES_DIR}/spinnaker_images.txt
    yq -r '.dependencies | to_entries | .[] | env(dockerhub_dockerRegistry) + .key + ":" + .value.version' ${spinnaker_bom} >> ${IMAGES_DIR}/spinnaker_images.txt

    sed -i "s#docker.io/library/redis:.*#docker.io/library/redis:6.2#g" ${IMAGES_DIR}/spinnaker_images.txt
    sed -i '/monitoring-third-party/d' ${IMAGES_DIR}/spinnaker_images.txt
    echo "${halyard_image}" >> ${IMAGES_DIR}/spinnaker_images.txt
    echo "docker.io/mikefarah/yq:4.40.2" >> ${IMAGES_DIR}/spinnaker_images.txt

    yq e -i '.services.*.version |= "local:" + .' ${spinnaker_bom}
    tar -zcvf etc/halconfig.tar.gz -C etc/ .
    rm -rf etc/halconfig

    DEPLOYMENT_FILE="manifests/halyard_deployment.yaml.tmpl"
    sed -i "/name: spinnaker_version/{n;s/value:.*/value: \"$spinnaker_version\"/}" $DEPLOYMENT_FILE
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        command_exists docker
        command_exists yq
        download_spinnaker_boms
        generate_spinnaker_images
    fi
}

main $@
