#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"rainbond"}
NAMESPACE=${NAMESPACE:-" rbd-system"}
HELM_OPTS=${HELM_OPTS:-""}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function log_error() {
  printf "%s \033[31merror \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log_error "$1 is required, exiting"
    exit 1
  fi
}

function install(){
  helm upgrade -i ${NAME} ./chart/rainbond-cluster -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

function uninstall(){
  if helm -n ${NAMESPACE} status ${NAME} &> /dev/null; then
    helm -n ${NAMESPACE} uninstall ${NAME} --wait --cascade='foreground' &> /dev/null
    log::info "${NAME} is uninstalled"

    # Delete PVC
    kubectl get pvc -n ${NAMESPACE} | grep -v NAME | awk '{print $1}' | xargs kubectl delete pvc -n rbd-system

    # Delete PV
    kubectl get pv | grep ${NAMESPACE} | grep -v NAME | awk '{print $1}' | xargs kubectl delete pv

    # Delete CRD
    kubectl delete crd componentdefinitions.rainbond.io \
    helmapps.rainbond.io \
    rainbondclusters.rainbond.io \
    rainbondpackages.rainbond.io \
    rainbondvolumes.rainbond.io \
    rbdcomponents.rainbond.io \
    servicemonitors.monitoring.coreos.com \
    thirdcomponents.rainbond.io \
    rbdabilities.rainbond.io \
    rbdplugins.rainbond.io \
    servicemeshclasses.rainbond.io \
    servicemeshes.rainbond.io \
    -n ${NAMESPACE}

    kubectl get apiservice | grep ${NAMESPACE} | grep False | awk '{print $1}' | xargs kubectl delete apiservice

    # Delete NAMESPACE
    kubectl delete ns ${NAMESPACE}

    # Delete Rainbond data dir
    rm -rf /opt/rainbond
  else
    log::info "${NAME} is not exits"
  fi
}

function main(){
  check_command helm
  if [ "$uninstall" = "true" ]; then
    uninstall
  else
    install
  fi
}

main $@
