#!/usr/bin/env bash
set -e

NAME=${NAME:-"gitlab"}
NAMESPACE=${NAMESPACE:-"gitlab"}
CHARTS=${CHARTS:-"./charts/gitlab"}
HELM_OPTS=${HELM_OPTS:-" \
--set nginx-ingress.controller.image.digest="" \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
