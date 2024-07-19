#!/bin/bash

set -eu

readonly ADD_IMAGES_LIST=${add_images?}
readonly APP_NAME=${app_name?}
readonly APP_VERSION=${app_version?}
readonly IMAGE_FILE_PATH=${images_file?}

echo "ADD_IMAGES_LIST:"${ADD_IMAGES_LIST}
echo "APP_NAME:"${APP_NAME}
echo "APP_VERSION:"${APP_VERSION}
echo "IMAGE_FILE_PATH:"${IMAGE_FILE_PATH}

add_images_list() {
    if [[ -z "${ADD_IMAGES_LIST}" ]]; then
        return
    fi

    if [[ ! -f "$IMAGE_FILE_PATH" ]]; then
#        IMAGE_FILE_PATH_LATEST=${IMAGE_FILE_PATH/${APP_VERSION}/latest}
#        if [[ -f "$IMAGE_FILE_PATH_LATEST" ]]; then
#            cp -af $IMAGE_FILE_PATH_LATEST $IMAGE_FILE_PATH
#        else
#            touch "$IMAGE_FILE_PATH"
#        fi
        touch "$IMAGE_FILE_PATH"
    fi
    echo "" >> $IMAGE_FILE_PATH
    for image in $(echo "$ADD_IMAGES_LIST" | sed 's/|/ /g'); do
        image_name="${image%:*}"
        exists_images_list="$(cat $IMAGE_FILE_PATH | (grep "$image_name" || true))"
        if [[ -z "$exists_images_list" ]]; then
            echo "$image" >> $IMAGE_FILE_PATH
            continue
        fi
        exists_flag=0
        for e_image in $(echo "$exists_images_list"); do
            if [[ "$image" == "$e_image" ]]; then
                exists_flag=1
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
                exists_flag=1
                break
            fi
        done
        if [[ $exists_flag -eq 0 ]]; then
            echo "$image" >> $IMAGE_FILE_PATH
        fi
    done
}

save_images_package() {
    if [[ ! -f "$IMAGE_FILE_PATH" ]]; then
        echo "no found save images file"
        return
    fi

    if [[ "${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-cloud" || "$APP_NAME" == "kubeblocks-enterprise-patch" ]]; then
        echo "change ${APP_NAME}.txt images tag"
        sed -i "s/^# kubeblocks-cloud .*/# kubeblocks-cloud :${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/openconsole:.*/docker.io\/apecloud\/openconsole:${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/apiserver:.*/docker.io\/apecloud\/apiserver:${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/task-manager:.*/docker.io\/apecloud\/task-manager:${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/cubetran-front:.*/docker.io\/apecloud\/cubetran-front:${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/cr4w:.*/docker.io\/apecloud\/cr4w:${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/prompt:.*/docker.io\/apecloud\/prompt:${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/relay:.*/docker.io\/apecloud\/relay:${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/sentry:.*/docker.io\/apecloud\/sentry:${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/sentry-init:.*/docker.io\/apecloud\/sentry-init:${APP_VERSION}/" $IMAGE_FILE_PATH
        sed -i "s/^docker.io\/apecloud\/kb-cloud-installer:.*/docker.io\/apecloud\/kb-cloud-installer:${APP_VERSION}/" $IMAGE_FILE_PATH
    fi

    app_package_name=${APP_NAME}-${APP_VERSION}.tar.gz
    save_flag=0
    for i in {1..10}; do
        save_cmd="docker save -o ${app_package_name} "
        while read -r image
        do
            if [[ -z "$image" || "$image" == "#"* ]]; then
                continue
            fi
            echo "pull image $image"
            for j in {1..10}; do
                docker pull "$image"
                ret_msg=$?
                if [[ $ret_msg -eq 0 ]]; then
                    echo "$(tput -T xterm setaf 2)pull image $image success$(tput -T xterm sgr0)"
                    break
                fi
                sleep 1
            done
            save_cmd="${save_cmd} $image "
        done < $IMAGE_FILE_PATH
        echo "$save_cmd"
        eval "$save_cmd"
        ret_msg=$?
        if [[ $ret_msg -eq 0 ]]; then
            echo "$(tput -T xterm setaf 2)save ${app_package_name} success$(tput -T xterm sgr0)"
            save_flag=1
            break
        fi
        sleep 1
    done
    if [[ $save_flag -eq 0 ]]; then
        echo "$(tput -T xterm setaf 1)save ${app_package_name} error$(tput -T xterm sgr0)"
        exit 1
    fi
}

main() {
    local UNAME=`uname -s`

    add_images_list

    save_images_package
}

main "$@"
