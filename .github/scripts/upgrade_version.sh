#!/bin/bash

set -eu


show_help() {
cat << EOF
Usage: $(basename "$0") <options>

    -h, --help                    Display help
    -t, --type                    Operation type
                                    1) upgrade version
    -cv, --cloud-version          KubeBlocks Cloud Version
    -kv, --kubeblocks-version     KubeBlocks Version
    -gv, --gemini-version         Gemini Version
    -ov, --oteld-version          Oteld Version
    -iv, --installer-version      Offline Installer Version
    -dv, --dms-version            Dms Version
EOF
}

parse_command_line() {
    while :; do
        case "${1:-}" in
            -h|--help)
                show_help
                exit
                ;;
            -t|--type)
                if [[ -n "${2:-}" ]]; then
                    TYPE="$2"
                    shift
                fi
                ;;
            -cv|--cloud-version)
                if [[ -n "${2:-}" ]]; then
                    CLOUD_VERSION="$2"
                    shift
                fi
                ;;
            -kv|--kubeblocks-version)
                if [[ -n "${2:-}" ]]; then
                    KUBEBLOCKS_VERSION="$2"
                    shift
                fi
                ;;
            -gv|--gemini-version)
                if [[ -n "${2:-}" ]]; then
                    GEMINI_VERSION="$2"
                    shift
                fi
                ;;
            -ov|--oteld-version)
                if [[ -n "${2:-}" ]]; then
                    OTELD_VERSION="$2"
                    shift
                fi
                ;;
            -iv|--installer-version)
                if [[ -n "${2:-}" ]]; then
                    OFFLINE_INSTALLER_VERSION="$2"
                    shift
                fi
                ;;
            -dv|--dms-version)
                if [[ -n "${2:-}" ]]; then
                    DMS_VERSION="$2"
                    shift
                fi
                ;;
            *)
                break
                ;;
        esac

        shift
    done
}

change_cloud_version() {
    echo "$(tput -T xterm setaf 3)change kubeblocks-cloud image version:${CLOUD_VERSION}$(tput -T xterm sgr0)"
    imageFiles=("kubeblocks-cloud.txt" "kubeblocks-enterprise.txt" "kubeblocks-enterprise-patch.txt")
    for imageFile in "${imageFiles[@]}"; do
        echo "change ${imageFile} images tag"
        image_file_path=.github/images/${imageFile}
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^# kubeblocks-cloud .*/# kubeblocks-cloud ${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/openconsole:.*/docker.io\/apecloud\/openconsole:${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/apiserver:.*/docker.io\/apecloud\/apiserver:${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/task-manager:.*/docker.io\/apecloud\/task-manager:${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/cubetran-front:.*/docker.io\/apecloud\/cubetran-front:${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/cr4w:.*/docker.io\/apecloud\/cr4w:${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/relay:.*/docker.io\/apecloud\/relay:${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/sentry:.*/docker.io\/apecloud\/sentry:${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/sentry-init:.*/docker.io\/apecloud\/sentry-init:${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/kb-cloud-installer:.*/docker.io\/apecloud\/kb-cloud-installer:${CLOUD_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/apecloud-charts:.*/docker.io\/apecloud\/apecloud-charts:${CLOUD_VERSION}/" $image_file_path
        else
            sed -i "s/^# kubeblocks-cloud .*/# kubeblocks-cloud ${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/openconsole:.*/docker.io\/apecloud\/openconsole:${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/apiserver:.*/docker.io\/apecloud\/apiserver:${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/task-manager:.*/docker.io\/apecloud\/task-manager:${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/cubetran-front:.*/docker.io\/apecloud\/cubetran-front:${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/cr4w:.*/docker.io\/apecloud\/cr4w:${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/relay:.*/docker.io\/apecloud\/relay:${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/sentry:.*/docker.io\/apecloud\/sentry:${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/sentry-init:.*/docker.io\/apecloud\/sentry-init:${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/kb-cloud-installer:.*/docker.io\/apecloud\/kb-cloud-installer:${CLOUD_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/apecloud-charts:.*/docker.io\/apecloud\/apecloud-charts:${CLOUD_VERSION}/" $image_file_path
        fi
    done
    echo "$(tput -T xterm setaf 3)change kubeblocks-cloud chart version:${CLOUD_VERSION}$(tput -T xterm sgr0)"
    chartFiles=("kubeblocks-cloud.txt" "kubeblocks-enterprise.txt")
    for chartFile in "${chartFiles[@]}"; do
        echo "change ${chartFile} chart version"
        chart_file_path=.github/charts/${chartFile}
        CLOUD_VERSION_TEMP=${CLOUD_VERSION}
        if [[ "${CLOUD_VERSION}" == "v"* ]]; then
            CLOUD_VERSION_TEMP="${CLOUD_VERSION/v/}"
        fi
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^kubeblocks-cloud:.*/kubeblocks-cloud:${CLOUD_VERSION}/" $chart_file_path
            sed -i '' "s/^kb-cloud-installer:.*/kb-cloud-installer:${CLOUD_VERSION_TEMP}/" $chart_file_path
        else
            sed -i "s/^kubeblocks-cloud:.*/kubeblocks-cloud:${CLOUD_VERSION}/" $chart_file_path
            sed -i "s/^kb-cloud-installer:.*/kb-cloud-installer:${CLOUD_VERSION_TEMP}/" $chart_file_path
        fi
    done
}

change_kubeblocks_version() {
    echo "$(tput -T xterm setaf 3)change kubeblocks image version:${KUBEBLOCKS_VERSION}$(tput -T xterm sgr0)"
    imageFiles=("kubeblocks.txt" "kubeblocks-enterprise.txt" "kubeblocks-enterprise-patch.txt")
    for imageFile in "${imageFiles[@]}"; do
        echo "change ${imageFile} images tag"
        image_file_path=.github/images/${imageFile}
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-tools:0.8.2/#docker.io\/apecloud\/kubeblocks-tools:0.8.2/" $image_file_path
            sed -i '' "s/^# kubeblocks .*/# kubeblocks v${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks:.*/docker.io\/apecloud\/kubeblocks:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-dataprotection:.*/docker.io\/apecloud\/kubeblocks-dataprotection:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-datascript:.*/docker.io\/apecloud\/kubeblocks-datascript:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-tools:.*/docker.io\/apecloud\/kubeblocks-tools:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-charts:.*/docker.io\/apecloud\/kubeblocks-charts:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i '' "s/^#docker.io\/apecloud\/kubeblocks-tools:0.8.2/docker.io\/apecloud\/kubeblocks-tools:0.8.2/" $image_file_path
        else
            sed -i "s/^docker.io\/apecloud\/kubeblocks-tools:0.8.2/#docker.io\/apecloud\/kubeblocks-tools:0.8.2/" $image_file_path
            sed -i "s/^# kubeblocks .*/# kubeblocks v${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/kubeblocks:.*/docker.io\/apecloud\/kubeblocks:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/kubeblocks-dataprotection:.*/docker.io\/apecloud\/kubeblocks-dataprotection:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/kubeblocks-datascript:.*/docker.io\/apecloud\/kubeblocks-datascript:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/kubeblocks-tools:.*/docker.io\/apecloud\/kubeblocks-tools:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/kubeblocks-charts:.*/docker.io\/apecloud\/kubeblocks-charts:${KUBEBLOCKS_VERSION}/" $image_file_path
            sed -i "s/^#docker.io\/apecloud\/kubeblocks-tools:0.8.2/docker.io\/apecloud\/kubeblocks-tools:0.8.2/" $image_file_path
        fi
    done

    echo "$(tput -T xterm setaf 3)change kubeblocks chart version:${KUBEBLOCKS_VERSION}$(tput -T xterm sgr0)"
    chartFiles=("kubeblocks.txt" "kubeblocks-enterprise.txt")
    for chartFile in "${chartFiles[@]}"; do
        echo "change ${chartFile} chart version"
        chart_file_path=.github/charts/${chartFile}
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^kubeblocks:.*/kubeblocks:${KUBEBLOCKS_VERSION}/" $chart_file_path
        else
            sed -i "s/^kubeblocks:.*/kubeblocks:${KUBEBLOCKS_VERSION}/" $chart_file_path
        fi
    done
}

change_gemini_version() {
    echo "$(tput -T xterm setaf 3)change gemini image version:${GEMINI_VERSION}$(tput -T xterm sgr0)"
    imageFiles=("gemini.txt" "kubeblocks-enterprise.txt" "kubeblocks-enterprise-patch.txt")
    for imageFile in "${imageFiles[@]}"; do
        echo "change ${imageFile} images tag"
        image_file_path=.github/images/${imageFile}
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^# gemini .*/# gemini v${GEMINI_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/gemini:.*/docker.io\/apecloud\/gemini:${GEMINI_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/gemini-tools:.*/docker.io\/apecloud\/gemini-tools:${GEMINI_VERSION}/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/easymetrics:.*/docker.io\/apecloud\/easymetrics:${GEMINI_VERSION}/" $image_file_path
        else
            sed -i "s/^# gemini .*/# gemini v${GEMINI_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/gemini:.*/docker.io\/apecloud\/gemini:${GEMINI_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/gemini-tools:.*/docker.io\/apecloud\/gemini-tools:${GEMINI_VERSION}/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/easymetrics:.*/docker.io\/apecloud\/easymetrics:${GEMINI_VERSION}/" $image_file_path
        fi
    done

    echo "$(tput -T xterm setaf 3)change gemini chart version:${GEMINI_VERSION}$(tput -T xterm sgr0)"
    chartFiles=("gemini.txt" "kubeblocks-enterprise.txt")
    for chartFile in "${chartFiles[@]}"; do
        echo "change ${chartFile} chart version"
        chart_file_path=.github/charts/${chartFile}
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^gemini:.*/gemini:${GEMINI_VERSION}/" $chart_file_path
            sed -i '' "s/^gemini-monitor:.*/gemini-monitor:${GEMINI_VERSION}/" $chart_file_path
        else
            sed -i "s/^gemini:.*/gemini:${GEMINI_VERSION}/" $chart_file_path
            sed -i "s/^gemini-monitor:.*/gemini-monitor:${GEMINI_VERSION}/" $chart_file_path
        fi
    done
}

change_oteld_version() {
    echo "$(tput -T xterm setaf 3)change oteld image version:${OTELD_VERSION}$(tput -T xterm sgr0)"
    imageFiles=("gemini.txt" "kubeblocks-enterprise.txt" "kubeblocks-enterprise-patch.txt")
    for imageFile in "${imageFiles[@]}"; do
        echo "change ${imageFile} images tag"
        image_file_path=.github/images/${imageFile}
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^docker.io\/apecloud\/oteld:0.5.2-k8s21/#docker.io\/apecloud\/oteld:0.5.2-k8s21/" $image_file_path
            sed -i '' "s/^docker.io\/apecloud\/oteld:.*/docker.io\/apecloud\/oteld:${OTELD_VERSION}/" $image_file_path
            sed -i '' "s/^#docker.io\/apecloud\/oteld:0.5.2-k8s21/docker.io\/apecloud\/oteld:0.5.2-k8s21/" $image_file_path
        else
            sed -i "s/^docker.io\/apecloud\/oteld:0.5.2-k8s212/#docker.io\/apecloud\/oteld:0.5.2-k8s21/" $image_file_path
            sed -i "s/^docker.io\/apecloud\/oteld:.*/docker.io\/apecloud\/oteld:${OTELD_VERSION}/" $image_file_path
            sed -i "s/^#docker.io\/apecloud\/oteld:0.5.2-k8s21/docker.io\/apecloud\/oteld:0.5.2-k8s21/" $image_file_path
        fi
    done
}

change_offline_installer_version() {
    echo "$(tput -T xterm setaf 3)change offline installer image version:${OFFLINE_INSTALLER_VERSION}$(tput -T xterm sgr0)"
    imageFiles=("kubeblocks-cloud.txt" "kubeblocks-enterprise.txt" "kubeblocks-enterprise-patch.txt")
    for imageFile in "${imageFiles[@]}"; do
        echo "change ${imageFile} images tag"
        image_file_path=.github/images/${imageFile}
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^docker.io\/apecloud\/kubeblocks-installer:.*/docker.io\/apecloud\/kubeblocks-installer:${OFFLINE_INSTALLER_VERSION}/" $image_file_path
        else
            sed -i "s/^docker.io\/apecloud\/kubeblocks-installer:.*/docker.io\/apecloud\/kubeblocks-installer:${OFFLINE_INSTALLER_VERSION}/" $image_file_path
        fi
    done
}

change_dms_version() {
    echo "$(tput -T xterm setaf 3)change dms image version:${DMS_VERSION}$(tput -T xterm sgr0)"
    imageFiles=("kubeblocks-cloud.txt" "kubeblocks-enterprise.txt" "kubeblocks-enterprise-patch.txt")
    for imageFile in "${imageFiles[@]}"; do
        echo "change ${imageFile} images tag"
        image_file_path=.github/images/${imageFile}
        if [[ "$UNAME" == "Darwin" ]]; then
            sed -i '' "s/^docker.io\/apecloud\/dms:.*/docker.io\/apecloud\/dms:${DMS_VERSION}/" $image_file_path
        else
            sed -i "s/^docker.io\/apecloud\/dms:.*/docker.io\/apecloud\/dms:${DMS_VERSION}/" $image_file_path
        fi
    done
}

main() {
    local TYPE=""
    local UNAME=`uname -s`
    local CLOUD_VERSION=""
    local KUBEBLOCKS_VERSION=""
    local GEMINI_VERSION=""
    local OTELD_VERSION=""
    local OFFLINE_INSTALLER_VERSION=""
    local DMS_VERSION=""

    parse_command_line "$@"

    echo "CLOUD_VERSION:"${CLOUD_VERSION}
    echo "KUBEBLOCKS_VERSION:"${KUBEBLOCKS_VERSION}
    echo "GEMINI_VERSION:"${GEMINI_VERSION}
    echo "OTELD_VERSION:"${OTELD_VERSION}
    echo "OFFLINE_INSTALLER_VERSION:"${OFFLINE_INSTALLER_VERSION}
    echo "DMS_VERSION:"${DMS_VERSION}

    case $TYPE in
        1)
            if [[ -n "$CLOUD_VERSION" ]]; then
                if [[ "${CLOUD_VERSION}" != "v"* ]]; then
                    CLOUD_VERSION="v${CLOUD_VERSION}"
                fi
                change_cloud_version "${CLOUD_VERSION}"
            fi

            if [[ -n "$KUBEBLOCKS_VERSION" ]]; then
                if [[ "${KUBEBLOCKS_VERSION}" == "v"* ]]; then
                    KUBEBLOCKS_VERSION="${KUBEBLOCKS_VERSION/v/}"
                fi
                change_kubeblocks_version
            fi

            if [[ -n "$GEMINI_VERSION" ]]; then
                if [[ "${GEMINI_VERSION}" == "v"* ]]; then
                    GEMINI_VERSION="${GEMINI_VERSION/v/}"
                fi
                change_gemini_version
            fi

            if [[ -n "$OTELD_VERSION" ]]; then
                if [[ "${OTELD_VERSION}" == "v"* ]]; then
                    OTELD_VERSION="${OTELD_VERSION/v/}"
                fi
                change_oteld_version
            fi

            if [[ -n "$OTELD_VERSION" ]]; then
                if [[ "${OTELD_VERSION}" == "v"* ]]; then
                    OTELD_VERSION="${OTELD_VERSION/v/}"
                fi
                change_oteld_version
            fi

            if [[ -n "$OFFLINE_INSTALLER_VERSION" ]]; then
                if [[ "${OFFLINE_INSTALLER_VERSION}" != *"-offline" ]]; then
                    OFFLINE_INSTALLER_VERSION="${OFFLINE_INSTALLER_VERSION}-offline"
                fi
                change_offline_installer_version
            fi

            if [[ -n "$DMS_VERSION" ]]; then
                if [[ "${DMS_VERSION}" == "v"* ]]; then
                    $DMS_VERSION="${DMS_VERSION/v/}"
                fi
                change_dms_version
            fi
        ;;
        *)
            show_help
        ;;
    esac
}

main "$@"
