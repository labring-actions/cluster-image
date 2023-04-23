#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"ingress-nginx"}
NAMESPACE=${NAMESPACE:-"ingress-nginx"}

function enable(){
  helm upgrade -i ${NAME} ../charts/ingress-nginx -n ${NAMESPACE} --create-namespace \
    --set controller.image.digest=null,controller.admissionWebhooks.patch.image.digest=null ${HELM_OPTS}
}
enable
