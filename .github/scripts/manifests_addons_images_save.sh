#!/bin/bash

MANIFESTS_FILE=${1:-"deploy-manifests.yaml"}
IMAGE_NAME=${2:-""}


pull_chart_images() {
    chart_images_tmp=$1
    for image in $(echo "$chart_images_tmp"); do
        repository="${SRC_REGISTRY}/${image}"
        echo "pull image $repository"
        for i in {1..10}; do
            docker pull "$repository"
            ret_msg=$?
            if [[ $ret_msg -eq 0 ]]; then
                echo "$(tput -T xterm setaf 2)pull image $repository success$(tput -T xterm sgr0)"
                break
            fi
            sleep 1
        done
        SAVE_CHART_IMAGES="$SAVE_CHART_IMAGES $repository"
    done
}

save_charts_images() {
    if [[ ! -f "${MANIFESTS_FILE}" ]]; then
        echo "$(tput -T xterm setaf 1)Not found manifests file:${MANIFESTS_FILE}$(tput -T xterm sgr0)"
        return
    fi

    if [[ -z "${IMAGE_NAME}" ]]; then
        echo "$(tput -T xterm setaf 1)Enable Addon Name is empty$(tput -T xterm sgr0)"
        return
    fi

    RELEASE_VERSION=$(yq e "."${IMAGE_NAME}"[0].version" ${MANIFESTS_FILE})
    IMAGE_PKG_NAME="${IMAGE_NAME}-images-${RELEASE_VERSION}.tar.gz"
    chart_images=$(yq e "."${IMAGE_NAME}"[].images[]" "${MANIFESTS_FILE}")
    if [[ -z "$chart_images" ]]; then
        echo "$(tput -T xterm setaf 3)Not found ${chart_name} images$(tput -T xterm sgr0)"
        exit 1
    fi

    pull_chart_images "$chart_images"

    echo " Pull images done!"

    save_cmd="docker save -o ${IMAGE_PKG_NAME} ${SAVE_CHART_IMAGES}"
    echo "$save_cmd"
    save_flag=0
    for i in {1..10}; do
        eval "$save_cmd"
        ret_msg=$?
        if [[ $ret_msg -eq 0 ]]; then
            echo "$(tput -T xterm setaf 2)save ${IMAGE_PKG_NAME} success$(tput -T xterm sgr0)"
            save_flag=1
            break
        fi
        sleep 1
    done
    rm -rf ${IMAGES_FILE_DIR}
    if [[ $save_flag -eq 0 ]]; then
        echo "$(tput -T xterm setaf 1)save ${IMAGE_PKG_NAME} error$(tput -T xterm sgr0)"
        exit 1
    fi
}

main() {
    local SRC_REGISTRY="docker.io"
    local IMAGE_PKG_NAME=""
    local SAVE_CHART_IMAGES=""

    save_charts_images
}

main "$@"
