#!/bin/bash

MANIFESTS_FILE=${1:-"deploy-manifests.yaml"}
VALUES_FILE=${2:-"deploy-values.yaml"}


get_manifests_addon() {
    if [[ ! -f "${MANIFESTS_FILE}" ]]; then
        echo "$(tput -T xterm setaf 1)Not found manifests file:${MANIFESTS_FILE} $(tput -T xterm sgr0)"
        return
    fi
    charts_name=$(yq e "to_entries|map(.key)|.[]"  "${MANIFESTS_FILE}")
    for chart_name in $(echo "$charts_name"); do
        is_addon=$(yq e "."${chart_name}"[0].isAddon" ${MANIFESTS_FILE})
        chart_enable=$(yq e ".${chart_name}.enable" "${VALUES_FILE}")
        if [[ "${is_addon}" == "true" && "${chart_enable}" == "true" ]]; then
            if [[ -z "$ADDONS_NAME" ]]; then
                ADDONS_NAME="{\"addon-name\":\"${chart_name}\"}"
            else
                ADDONS_NAME="$ADDONS_NAME,{\"addon-name\":\"${chart_name}\"}"
            fi
        fi
    done
    echo "$ADDONS_NAME"
}

main() {
    local ADDONS_NAME=""
    get_manifests_addon
}

main "$@"
