#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"jenkins"}
NAMESPACE=${NAMESPACE:-"jenkins"}
HELM_OPTS=${HELM_OPTS:-"--set controller.adminPassword=jenkins \
--set controller.installLatestPlugins=false \
--set controller.serviceType=NodePort \
--set controller.initContainerEnv[0].name=JENKINS_UC \
--set controller.initContainerEnv[0].value=https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json \
--set controller.initContainerEnv[1].name=JENKINS_UC_DOWNLOAD \
--set controller.initContainerEnv[1].value=https://mirrors.tuna.tsinghua.edu.cn/jenkins"}

function install(){
  helm upgrade -i ${NAME} ./charts/jenkins -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
}

install
