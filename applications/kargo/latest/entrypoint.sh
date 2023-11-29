#!/usr/bin/env bash
set -e

NAME=${NAME:-"kargo"}
NAMESPACE=${NAMESPACE:-"kargo"}
CHARTS=${CHARTS:-"./charts/kargo"}
HELM_OPTS=${HELM_OPTS:-" \
--set api.adminAccount.password=admin \
--set api.adminAccount.tokenSigningKey=iwishtowashmyirishwristwatch \
--set api.service.type=NodePort \
"}

cp -f opt/kargo /usr/local/bin/
helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
