#!/bin/bash

MANIFESTS_FILE=${1:-"deploy-manifests.yaml"}
VALUES_FILE=${2:-"deploy-values.yaml"}
RELEASE_VERSION=${3:-""}
KB_IMAGE_NAME=${4:-"kubeblocks-enterprise-images"}


pull_chart_images() {
    chart_images_file_tmp=$1
    chart_images_tmp=$2
    images_file_tmp=""
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
        images_file_tmp=$(cat "${chart_images_file_tmp}")
        echo "${images_file_tmp} $repository" > "${chart_images_file_tmp}"
    done
    images_file_tmp=$(cat "${chart_images_file_tmp}")
    echo -n "${images_file_tmp}" >> "${IMAGES_FILE_PATH}"
    echo "==========================================="
    df -h
    echo "==========================================="
}

save_charts_images() {
    if [[ ! -f "${MANIFESTS_FILE}" || ! -f "${VALUES_FILE}" ]]; then
        echo "$(tput -T xterm setaf 1)Not found manifests file:${MANIFESTS_FILE} or ${VALUES_FILE}$(tput -T xterm sgr0)"
        return
    fi
    mkdir ${IMAGES_FILE_DIR}
    IMAGES_FILE_PATH=${IMAGES_FILE_DIR}/${IMAGES_FILE}
    touch "${IMAGES_FILE_PATH}"

    charts_name=$(yq e "to_entries|map(.key)|.[]"  "${MANIFESTS_FILE}")
    for chart_name in $(echo "$charts_name"); do
        chart_enable=$(yq e ".${chart_name}.enable" "${VALUES_FILE}")
        if [[ "${chart_enable}" == "false" ]]; then
            echo "$(tput -T xterm setaf 3)skip pull ${chart_name} images$(tput -T xterm sgr0)"
            continue
        fi

        chart_images=$(yq e "."${chart_name}"[].images[]"  "${MANIFESTS_FILE}")
        if [[ -z "$chart_images" ]]; then
            echo "$(tput -T xterm setaf 3)Not found ${chart_name} images$(tput -T xterm sgr0)"
            continue
        fi
        case $chart_name in
            kubeblocks-cloud)
                chart_version=$(yq e "."${chart_name}"[0].version"  "${MANIFESTS_FILE}")
                if [[ -z "$RELEASE_VERSION" ]]; then
                    RELEASE_VERSION="${chart_version}"
                elif [[ "$RELEASE_VERSION" != "v"* ]]; then
                    RELEASE_VERSION="v${RELEASE_VERSION}"
                fi
                IMAGE_PKG_NAME="${KB_IMAGE_NAME}-${RELEASE_VERSION}.tar.gz"
            ;;
        esac

        chart_images_file="${IMAGES_FILE_DIR}/${chart_name}_${IMAGES_FILE}"
        touch "${chart_images_file}"

        pull_chart_images "$chart_images_file" "$chart_images" &
    done
    wait
    echo "
      Pull images done!
    "

    images_file=$(cat ${IMAGES_FILE_PATH})
    if [[ -z "${images_file}" ]]; then
        echo "$(tput -T xterm setaf 1)Images file is empty!$(tput -T xterm sgr0)"
        return
    fi

    save_cmd="docker save -o ${IMAGE_PKG_NAME} ${images_file}"
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
    local IMAGES_FILE_DIR="images_file_tmp"
    local IMAGES_FILE="images_file.txt"

    save_charts_images
}

main "$@"
