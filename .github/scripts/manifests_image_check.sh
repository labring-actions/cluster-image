#!/usr/bin/env bash
MANIFESTS_FILE=${1:-""}
IMAGE_REGISTRY=${2:-""}

main() {
    touch exit_result
    checked_images_list=""
    echo 0 > exit_result

    if [[ ! -f "${MANIFESTS_FILE}" ]]; then
        echo "$(tput -T xterm setaf 1)::error title=Not found manifests file:${MANIFESTS_FILE} $(tput -T xterm sgr0)"
        echo 1 > exit_result
        return
    fi

    images=$(yq e ".*[].images[]" ${MANIFESTS_FILE})
    if [[ -z "${images}"  ]]; then
        echo "$(tput -T xterm setaf 3)::warning title=No images found in manifests file:${MANIFESTS_FILE} $(tput -T xterm sgr0)"
        return
    fi

    for image in $( echo "$images" ); do
        repository=""

        if [[ "${image}" == "apecloud/"* && -n "${IMAGE_REGISTRY}" ]]; then
            repository="${IMAGE_REGISTRY}/${image}"
        else
            repository=${image}
        fi

        checked_flag=0
        for checked_image in $(echo "${checked_images_list}" | sed 's/|/ /g'); do
            if [[ "$repository" == "$checked_image" ]]; then
                checked_flag=1
                break
            fi
        done
        if [[ $checked_flag -eq 1 ]]; then
            echo "$(tput -T xterm setaf 7)$repository already checked$(tput -T xterm sgr0)"
            repository=""
            continue
        else
            checked_images_list="${checked_images_list}|$repository"
        fi
        echo "check image: $repository"
        check_image_exists "$repository" &
        repository=""
    done
    wait
    cat exit_result
    exit $(cat exit_result)
}

check_image_exists() {
    image=$1
    for i in {1..5}; do
        image_inspect=$( docker buildx imagetools inspect "$image" )
        image_digest=$( echo "$image_inspect" | (grep Digest || true))
        image_platform=$( echo "$image_inspect" | (grep Platform || true))
        if [[ -z "$image_inspect" && -z "$image_platform" && -z "$image_digest" ]]; then
            if [[ $i -lt 5 ]]; then
                sleep 1
                continue
            fi
        else
            if [[ -n "$image_platform" ]]; then
                if [[ "$image_platform" == *"amd64"* ]]; then
                    echo "$(tput -T xterm setaf 3)$image found amd64 architecture$(tput -T xterm sgr0)"
                fi

                if [[ "$image_platform" == *"arm64"* ]]; then
                    echo "$(tput -T xterm setaf 3)$image found arm64 architecture$(tput -T xterm sgr0)"
                fi
            fi
            if [[ -n "$image_platform" || -n "$image_digest" ]]; then
                echo "$(tput -T xterm setaf 2)$image found$(tput -T xterm sgr0)"
                break
            fi
        fi
        echo "$(tput -T xterm setaf 1)$image is not exists.$(tput -T xterm sgr0)"
        echo 1 > exit_result
    done
}

main "$@"
