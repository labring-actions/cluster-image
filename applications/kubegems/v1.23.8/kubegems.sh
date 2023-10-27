#!/bin/bash

NAME=${NAME:-"kubegems"}
NAMESPACE=${NAMESPACE:-"kubegems"}
VERSION=${VERSION:-"1.23.8"}
CHARTS=${CHARTS:-"./chart/kubegems"}
HELM_OPTS=${HELM_OPTS:-"--set ingress.enable=false --set dashboard.service.type=NodePort"}

helm upgrade -i kubegems-installer ./chart/kubegems-installer --version=${VERSION} -n kubegems-installer --create-namespace --wait
helm upgrade -i ${NAME} ${CHARTS} --version=${VERSION} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
