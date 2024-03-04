#!/bin/bash

set -eu

readonly ADD_CHARTS_LIST=${add_charts?}
readonly APP_NAME=${app_name?}
readonly APP_VERSION=${app_version?}
readonly CHART_FILE_PATH=${charts_file?}

echo "ADD_CHARTS_LIST:"${ADD_CHARTS_LIST}
echo "APP_NAME:"${APP_NAME}
echo "APP_VERSION:"${APP_VERSION}
echo "CHART_FILE_PATH:"${CHART_FILE_PATH}

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
    mkdir -p ${KB_CHART_NAME}

    if [[ -z "${APP_VERSION}" && "$APP_NAME" == "kubeblocks-enterprise" ]]; then
        wget ${KB_REPO_URL}/${APP_VERSION}/kubeblocks_crds.yaml -d ${KB_CHART_NAME}
    fi

    tar_flag=0
    for i in {1..10}; do
        while read -r chart
        do
            if [[ -z "$chart" || "$chart" == "#"* ]]; then
                continue
            fi
            chart=${chart/:/-}
            echo "fetch chart $chart"
            for j in {1..10}; do
                helm fetch -d ${KB_CHART_NAME} "$REPO_URL/${chart}/${chart}.tgz"
                ret_msg=$?
                if [[ $ret_msg -eq 0 ]]; then
                    echo "$(tput -T xterm setaf 2)fetch chart $chart success$(tput -T xterm sgr0)"
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
    local KB_CHART_NAME="${APP_NAME}-charts"
    local APP_PKG_NAME="${KB_CHART_NAME}-${APP_VERSION}.tar.gz"

    add_charts_list

    tar_charts_package
}

main "$@"
