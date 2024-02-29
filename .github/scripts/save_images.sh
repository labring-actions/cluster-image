#!/bin/bash

set -eu

readonly ADD_IMAGES_LIST=${add_images?}
readonly APP_NAME=${app_name?}
readonly APP_VERSION=${app_version?}
readonly IMAGE_FILE_PATH=${images_file?}

add_images_list() {
    if [[ -z "${ADD_IMAGES_LIST}" ]]; then
        return
    fi

    if [[ ! -f "$IMAGE_FILE_PATH" ]]; then
        touch "$IMAGE_FILE_PATH"
    fi

    for image in `echo "$ADD_IMAGES_LIST" | sed 's/|/ /g'`; do
        image_name="${image%:*}"
        exists_images_list="$(cat $IMAGE_FILE_PATH | grep "$image_name")"
        if [[ -z "$exists_images_list" ]]; then
            echo "$image" >> $IMAGE_FILE_PATH
            continue
        fi

        for e_image in $(echo "$exists_images_list"); do
            if [[ "$image" == "$e_image" ]]; then
                  break
            fi
            e_image_name="${e_image%:*}"
            if [[ "$e_image_name" == "$image_name" ]]; then
                e_image_tmp=$( echo ${e_image}| sed 's/\./\\./g;s/\//\\\//g' )
                image_tmp=$( echo ${image}| sed 's/\./\\./g;s/\//\\\//g' )
                if [[ "$UNAME" == "Darwin" ]]; then
                    sed -i '' "s/${e_image_tmp}/${image_tmp}/" $IMAGE_FILE_PATH
                else
                    sed -i "s/${e_image_tmp}/${image_tmp}/" $IMAGE_FILE_PATH
                fi
            fi
        done
    done
}

main() {
    local UNAME=`uname -s`

    add_images_list


}

main "$@"
