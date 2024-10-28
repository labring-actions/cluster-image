#!/bin/bash

set -eu

readonly ADD_CHARTS_LIST=${add_charts?}
readonly APP_NAME=${app_name?}
readonly CHART_FILE_PATH=${charts_file?}
readonly APP_VERSION_TMP=${app_version?}
readonly KUBEBLOCKS_VERSION_TMP="${kubeblocks_version?}"
readonly GEMINI_VERSION_TMP="${gemini_version?}"
readonly OTELD_VERSION_TMP="${oteld_version?}"
readonly OFFLINE_INSTALLER_VERSION_TMP="${installer_version?}"
readonly DMS_VERSION_TMP="${dms_version?}"

echo "ADD_CHARTS_LIST:"${ADD_CHARTS_LIST}
echo "APP_NAME:"${APP_NAME}
echo "CHART_FILE_PATH:"${CHART_FILE_PATH}
echo "APP_VERSION:"${APP_VERSION_TMP}
echo "CLOUD_VERSION:"${APP_VERSION_TMP}
echo "KUBEBLOCKS_VERSION:"${KUBEBLOCKS_VERSION_TMP}
echo "GEMINI_VERSION:"${GEMINI_VERSION_TMP}
echo "OTELD_VERSION:"${OTELD_VERSION_TMP}
echo "OFFLINE_INSTALLER_VERSION:"${OFFLINE_INSTALLER_VERSION_TMP}
echo "DMS_VERSION:"${DMS_VERSION_TMP}

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

change_charts_version() {
    IMAGE_FILE_PATH=$1
    if [[ "${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-cloud" || "$APP_NAME" == "kubeblocks-enterprise-patch" ]]; then
        echo "change ${APP_NAME}.txt images tag"
        if [[ "${APP_VERSION}" != "v"* ]]; then
            APP_VERSION="v${APP_VERSION}"
        fi
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^# KubeBlocks-Cloud .*/# KubeBlocks-Cloud ${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/openconsole:.*/docker.io\/apecloud\/openconsole:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/apiserver:.*/docker.io\/apecloud\/apiserver:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/task-manager:.*/docker.io\/apecloud\/task-manager:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/cubetran-front:.*/docker.io\/apecloud\/cubetran-front:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/cr4w:.*/docker.io\/apecloud\/cr4w:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/relay:.*/docker.io\/apecloud\/relay:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/sentry:.*/docker.io\/apecloud\/sentry:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/sentry-init:.*/docker.io\/apecloud\/sentry-init:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/kb-cloud-installer:.*/docker.io\/apecloud\/kb-cloud-installer:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/apecloud-charts:.*/docker.io\/apecloud\/apecloud-charts:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/apecloud-addon-charts:.*/docker.io\/apecloud\/apecloud-addon-charts:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/kb-cloud-hook:.*/docker.io\/apecloud\/kb-cloud-hook:${APP_VERSION}/" $IMAGE_FILE_PATH
        else
            sed -i "s/^# KubeBlocks-Cloud .*/# KubeBlocks-Cloud ${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/openconsole:.*/docker.io\/apecloud\/openconsole:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/apiserver:.*/docker.io\/apecloud\/apiserver:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/task-manager:.*/docker.io\/apecloud\/task-manager:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/cubetran-front:.*/docker.io\/apecloud\/cubetran-front:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/cr4w:.*/docker.io\/apecloud\/cr4w:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/relay:.*/docker.io\/apecloud\/relay:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/sentry:.*/docker.io\/apecloud\/sentry:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/sentry-init:.*/docker.io\/apecloud\/sentry-init:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/kb-cloud-installer:.*/docker.io\/apecloud\/kb-cloud-installer:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/apecloud-charts:.*/docker.io\/apecloud\/apecloud-charts:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/apecloud-addon-charts:.*/docker.io\/apecloud\/apecloud-addon-charts:${APP_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/kb-cloud-hook:.*/docker.io\/apecloud\/kb-cloud-hook:${APP_VERSION}/" $IMAGE_FILE_PATH
        fi
    fi

    if [[ ("${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-enterprise-patch") && -n "$KUBEBLOCKS_VERSION" ]]; then
        echo "change KubeBlocks images tag"
        if [[ "${KUBEBLOCKS_VERSION}" == "v"* ]]; then
            KUBEBLOCKS_VERSION="${KUBEBLOCKS_VERSION/v/}"
        fi
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^# KubeBlocks .*/# KubeBlocks v${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-tools:0.8.2/#docker.io\/apecloud\/kubeblocks-tools:0.8.2/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks:.*/docker.io\/apecloud\/kubeblocks:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-dataprotection:.*/docker.io\/apecloud\/kubeblocks-dataprotection:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-datascript:.*/docker.io\/apecloud\/kubeblocks-datascript:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-tools:.*/docker.io\/apecloud\/kubeblocks-tools:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-charts:.*/docker.io\/apecloud\/kubeblocks-charts:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^#docker.io\/apecloud\/kubeblocks-tools:0.8.2/docker.io\/apecloud\/kubeblocks-tools:0.8.2/" $IMAGE_FILE_PATH
        else
            sed -i "s/^# KubeBlocks .*/# KubeBlocks v${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/kubeblocks-tools:0.8.2/#docker.io\/apecloud\/kubeblocks-tools:0.8.2/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/kubeblocks:.*/docker.io\/apecloud\/kubeblocks:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/kubeblocks-dataprotection:.*/docker.io\/apecloud\/kubeblocks-dataprotection:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/kubeblocks-datascript:.*/docker.io\/apecloud\/kubeblocks-datascript:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/kubeblocks-tools:.*/docker.io\/apecloud\/kubeblocks-tools:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/kubeblocks-charts:.*/docker.io\/apecloud\/kubeblocks-charts:${KUBEBLOCKS_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^#docker.io\/apecloud\/kubeblocks-tools:0.8.2/docker.io\/apecloud\/kubeblocks-tools:0.8.2/" $IMAGE_FILE_PATH
        fi
    fi

    if [[ ("${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-enterprise-patch") && -n "$GEMINI_VERSION" ]]; then
        echo "change Gemini images tag"
        if [[ "${GEMINI_VERSION}" == "v"* ]]; then
            GEMINI_VERSION="${GEMINI_VERSION/v/}"
        fi
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^# Gemini .*/# Gemini v${GEMINI_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/gemini:.*/docker.io\/apecloud\/gemini:${GEMINI_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/gemini-tools:.*/docker.io\/apecloud\/gemini-tools:${GEMINI_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/easymetrics:.*/docker.io\/apecloud\/easymetrics:${GEMINI_VERSION}/" $IMAGE_FILE_PATH
        else
            sed -i "s/^# Gemini .*/# Gemini v${GEMINI_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/gemini:.*/docker.io\/apecloud\/gemini:${GEMINI_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/gemini-tools:.*/docker.io\/apecloud\/gemini-tools:${GEMINI_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/easymetrics:.*/docker.io\/apecloud\/easymetrics:${GEMINI_VERSION}/" $IMAGE_FILE_PATH
        fi
    fi

    if [[ ("${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-enterprise-patch") && -n "$OTELD_VERSION" ]]; then
        echo "change Oteld images tag"
        if [[ "${OTELD_VERSION}" == "v"* ]]; then
            OTELD_VERSION="${OTELD_VERSION/v/}"
        fi
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^docker.io\/apecloud\/oteld:0.5.2-k8s21/#docker.io\/apecloud\/oteld:0.5.2-k8s21/" $IMAGE_FILE_PATH
            sed -i '' "s/^docker.io\/apecloud\/oteld:.*/docker.io\/apecloud\/oteld:${OTELD_VERSION}/" $IMAGE_FILE_PATH
            sed -i '' "s/^#docker.io\/apecloud\/oteld:0.5.2-k8s21/docker.io\/apecloud\/oteld:0.5.2-k8s21/" $IMAGE_FILE_PATH
        else
            sed -i "s/^docker.io\/apecloud\/oteld:0.5.2-k8s21/#docker.io\/apecloud\/oteld:0.5.2-k8s21/" $IMAGE_FILE_PATH
            sed -i "s/^docker.io\/apecloud\/oteld:.*/docker.io\/apecloud\/oteld:${OTELD_VERSION}/" $IMAGE_FILE_PATH
            sed -i "s/^#docker.io\/apecloud\/oteld:0.5.2-k8s21/docker.io\/apecloud\/oteld:0.5.2-k8s21/" $IMAGE_FILE_PATH
        fi
    fi

    if [[ ("${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-enterprise-patch") && -n "$OFFLINE_INSTALLER_VERSION" ]]; then
        echo "change Offline Installer images tag"
        if [[ "${OFFLINE_INSTALLER_VERSION}" != *"-offline" ]]; then
            OFFLINE_INSTALLER_VERSION="${OFFLINE_INSTALLER_VERSION}-offline"
        fi
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-installer:.*/docker.io\/apecloud\/kubeblocks-installer:${OFFLINE_INSTALLER_VERSION}/" $IMAGE_FILE_PATH
        else
            sed -i "s/^docker.io\/apecloud\/kubeblocks-installer:.*/docker.io\/apecloud\/kubeblocks-installer:${OFFLINE_INSTALLER_VERSION}/" $IMAGE_FILE_PATH
        fi
    fi

    if [[ ("${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-enterprise-patch") && -n "$DMS_VERSION" ]]; then
        echo "change Dms images tag"
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^docker.io\/apecloud\/dms:.*/docker.io\/apecloud\/dms:${DMS_VERSION}/" $IMAGE_FILE_PATH
        else
            sed -i "s/^docker.io\/apecloud\/dms:.*/docker.io\/apecloud\/dms:${DMS_VERSION}/" $IMAGE_FILE_PATH
        fi
    fi
}

tar_charts_package() {
    if [[ ! -f "$CHART_FILE_PATH" ]]; then
        echo "no found tar charts file"
        return
    fi
    mkdir -p ${KB_CHART_NAME}/kubeblocks-image-list ${KB_CHART_NAME}/apps

    image_file_path=.github/images/${APP_NAME}.txt
    change_charts_version "$image_file_path"

    image_file_path2=.github/images/kubeblocks-enterprise-patch.txt
    change_charts_version "$image_file_path2"

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
        wget ${KB_REPO_URL}/v${KUBEBLOCKS_VERSION}/kubeblocks_crds.yaml -O kubeblocks_crds.yaml
        mv kubeblocks_crds.yaml ${KB_CHART_NAME}
    fi

    if [[ "${APP_NAME}" == "kubeblocks-enterprise" || "$APP_NAME" == "kubeblocks-cloud" ]]; then
        echo "change ${APP_NAME} chart version"
        APP_VERSION_TEMP=${APP_VERSION}
        if [[ "${APP_VERSION}" == "v"* ]]; then
            APP_VERSION_TEMP="${APP_VERSION/v/}"
        fi
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^kubeblocks-cloud:.*/kubeblocks-cloud:${APP_VERSION}/" $CHART_FILE_PATH
            sed -i '' "s/^kb-cloud-installer:.*/kb-cloud-installer:${APP_VERSION_TEMP}/" $CHART_FILE_PATH
        else
            sed -i "s/^kubeblocks-cloud:.*/kubeblocks-cloud:${APP_VERSION}/" $CHART_FILE_PATH
            sed -i "s/^kb-cloud-installer:.*/kb-cloud-installer:${APP_VERSION_TEMP}/" $CHART_FILE_PATH
        fi
    fi

    if [[ "${APP_NAME}" == "kubeblocks-enterprise" && -n "$KUBEBLOCKS_VERSION" ]]; then
        echo "change KubeBlocks chart version"
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^kubeblocks:.*/kubeblocks:${KUBEBLOCKS_VERSION}/" $CHART_FILE_PATH
        else
            sed -i "s/^kubeblocks:.*/kubeblocks:${KUBEBLOCKS_VERSION}/" $CHART_FILE_PATH
        fi
    fi

    if [[ "${APP_NAME}" == "kubeblocks-enterprise" && -n "$GEMINI_VERSION" ]]; then
        echo "change Gemini chart version"
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^gemini:.*/gemini:${GEMINI_VERSION}/" $CHART_FILE_PATH
            sed -i '' "s/^gemini-monitor:.*/gemini-monitor:${GEMINI_VERSION}/" $CHART_FILE_PATH
        else
            sed -i "s/^gemini:.*/gemini:${GEMINI_VERSION}/" $CHART_FILE_PATH
            sed -i "s/^gemini-monitor:.*/gemini-monitor:${GEMINI_VERSION}/" $CHART_FILE_PATH
        fi
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
            if [[ "$chart_tmp" == "starrocks"* || "$chart_tmp" == "oceanbase"* || "$chart_tmp" == "kubeblocks-cloud"* || "$chart_tmp" == "damengdb"* || "$chart_tmp" == "kingbase"* ]]; then
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
    local APP_VERSION=${APP_VERSION_TMP}
    local KUBEBLOCKS_VERSION="${KUBEBLOCKS_VERSION_TMP}"
    local GEMINI_VERSION="${GEMINI_VERSION_TMP}"
    local OTELD_VERSION="${OTELD_VERSION_TMP?}"
    local OFFLINE_INSTALLER_VERSION="${OFFLINE_INSTALLER_VERSION_TMP}"
    local DMS_VERSION="${DMS_VERSION_TMP}"
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
