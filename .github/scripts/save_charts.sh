#!/bin/bash

set -eu

readonly ADD_CHARTS_LIST=${add_charts?}
readonly APP_NAME=${app_name?}
readonly APP_VERSION=${app_version?}
readonly CHART_FILE_PATH=${charts_file?}
readonly KUBEBLOCKS_VERSION=${kubeblocks_version?}

echo "ADD_CHARTS_LIST:"${ADD_CHARTS_LIST}
echo "APP_NAME:"${APP_NAME}
echo "APP_VERSION:"${APP_VERSION}
echo "CHART_FILE_PATH:"${CHART_FILE_PATH}
echo "KUBEBLOCKS_VERSION:"${KUBEBLOCKS_VERSION}

add_charts_list() {
    if [[ -z "${ADD_CHARTS_LIST}" ]]; then
        return
    fi

    if [[ ! -f "$CHART_FILE_PATH" ]]; then
        touch "$CHART_FILE_PATH"
    fi
    echo "" >> $CHART_FILE_PATH
    for chart in $(echo "$ADD_CHARTS_LIST" | sed 's/|/ /g'); do
        chart_name="${chart%:*}"
        exists_charts_list="$(cat $CHART_FILE_PATH | (grep "$chart_name" || true))"
        if [[ -z "$exists_charts_list" ]]; then
            echo "$chart" >> $CHART_FILE_PATH
            continue
        fi
        exists_flag=0
        for e_chart in $(echo "$exists_charts_list"); do
            if [[ "$chart" == "$e_chart" ]]; then
                exists_flag=1
                break
            fi
            e_chart_name="${e_chart%:*}"
            if [[ "$e_chart_name" == "$chart_name" ]]; then
                e_chart_tmp=$( echo ${e_chart}| sed 's/\./\\./g;s/\//\\\//g' )
                chart_tmp=$( echo ${chart}| sed 's/\./\\./g;s/\//\\\//g' )
                if [[ "$UNAME" == "Darwin" ]]; then
                    sed -i '' "s/${e_chart_tmp}/${chart_tmp}/" $CHART_FILE_PATH
                else
                    sed -i "s/${e_chart_tmp}/${chart_tmp}/" $CHART_FILE_PATH
                fi
                exists_flag=1
                break
            fi
        done
        if [[ $exists_flag -eq 0 ]]; then
            echo "$chart" >> $CHART_FILE_PATH
        fi
    done
}

tar_charts_package() {
    if [[ ! -f "$CHART_FILE_PATH" ]]; then
        echo "no found tar charts file"
        return
    fi
    mkdir -p ${KB_CHART_NAME}/kubeblocks-image-list ${KB_CHART_NAME}/apps

    if [[ "${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-cloud" ]]; then
        echo "change ${APP_NAME}.txt images tag"
        IMAGE_FILE_PATH=.github/images/${APP_NAME}.txt
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

    echo "copy image-list.txt"
    if [[ "${APP_NAME}" == "kubeblocks-enterprise" ]]; then
        cp -r .github/images/*.txt ${KB_CHART_NAME}/kubeblocks-image-list/
        echo "copy apps yaml "
        cp -r .github/apps/* ${KB_CHART_NAME}/apps/
    else
        cp -r .github/images/${APP_NAME}.txt ${KB_CHART_NAME}/kubeblocks-image-list/
    fi
    if [[ -n "${KUBEBLOCKS_VERSION}" && ("$APP_NAME" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks" ) ]]; then
        echo "download Kubeblocks crds"
        wget ${KB_REPO_URL}/${KUBEBLOCKS_VERSION}/kubeblocks_crds.yaml -O kubeblocks_crds.yaml
        mv kubeblocks_crds.yaml ${KB_CHART_NAME}
    fi

    if [[ "${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-cloud" ]]; then
        echo "change ${APP_NAME} chart version"
        APP_VERSION_TEMP=${APP_VERSION}
        if [[ "${APP_VERSION}" == "v"* ]]; then
            APP_VERSION_TEMP="${APP_VERSION/v/}"
        fi
        sed -i "s/^kubeblocks-cloud:.*/kubeblocks-cloud:${APP_VERSION}/" $CHART_FILE_PATH
        sed -i "s/^kb-cloud-installer:.*/kb-cloud-installer:${APP_VERSION_TEMP}/" $CHART_FILE_PATH
    fi
    tar_flag=0
    for i in {1..10}; do
        while read -r chart
        do
            ent_flag=0
            if [[ -z "$chart" || "$chart" == "#"* ]]; then
                continue
            fi
            chart_tmp=${chart/:/-}
            chart_name=${chart%:*}
            chart_version=${chart#*:}
            if [[ "$chart_tmp" == "starrocks"* || "$chart_tmp" == "oceanbase"* ]]; then
                helm repo add ${ENT_REPO_NAME} --username ${CHART_ACCESS_USER} --password ${CHART_ACCESS_TOKEN} ${KB_ENT_REPO_URL}
                helm repo update ${ENT_REPO_NAME}
                ent_flag=1
            fi
            echo "fetch chart $chart_tmp"
            for j in {1..10}; do
                if [[ $ent_flag -eq 1 ]]; then
                    helm pull -d ${KB_CHART_NAME} ${ENT_REPO_NAME}/${chart_name} --version ${chart_version}
                else
                    helm fetch -d ${KB_CHART_NAME} "$REPO_URL/${chart_tmp}/${chart_tmp}.tgz"
                fi
                ret_msg=$?
                if [[ $ret_msg -eq 0 ]]; then
                    echo "$(tput -T xterm setaf 2)fetch chart $chart_tmp success$(tput -T xterm sgr0)"
                    break
                fi
                sleep 1
            done
        done < $CHART_FILE_PATH
        echo "tar ${KB_CHART_NAME}"
        tar -czvf ${APP_PKG_NAME} ${KB_CHART_NAME}
        ret_msg=$?
        if [[ $ret_msg -eq 0 ]]; then
            echo "$(tput -T xterm setaf 2)tar ${APP_PKG_NAME} success$(tput -T xterm sgr0)"
            tar_flag=1
            break
        fi
        sleep 1
    done
    if [[ $tar_flag -eq 0 ]]; then
        echo "$(tput -T xterm setaf 1)tar ${APP_PKG_NAME} error$(tput -T xterm sgr0)"
        exit 1
    fi
}

main() {
    local UNAME=`uname -s`
    local REPO_URL="https://github.com/apecloud/helm-charts/releases/download"
    local KB_REPO_URL="https://github.com/apecloud/kubeblocks/releases/download"
    local KB_ENT_REPO_URL="https://jihulab.com/api/v4/projects/${CHART_PROJECT_ID}/packages/helm/stable"
    local ENT_REPO_NAME="kb-ent"
    local KB_CHART_NAME="${APP_NAME}-charts"
    local APP_PKG_NAME="${KB_CHART_NAME}-${APP_VERSION}.tar.gz"

    add_charts_list

    tar_charts_package
}

main "$@"
