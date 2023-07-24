#!/bin/bash

IP="${IP:-127.0.0.1}"
PORT="${PORT:-30080}"
HELM_OPTS="${HELM_OPTS:-}"

helm upgrade --install zadig charts/zadig --namespace zadig-system --create-namespace  --set endpoint.type=IP \
    --set endpoint.IP=${IP} \
    --set tags.minio=true \
    --set gloo.gatewayProxies.gatewayProxy.service.httpNodePort=${PORT} \
    --set global.extensions.extAuth.extauthzServerRef.namespace=zadig-system \
    --set gloo.gatewayProxies.gatewayProxy.service.type=NodePort \
    --set "dex.config.staticClients[0].redirectURIs[0]=http://${IP}:${PORT}/api/v1/callback,dex.config.staticClients[0].id=zadig,dex.config.staticClients[0].name=zadig,dex.config.staticClients[0].secret=ZXhhbXBsZS1hcHAtc2VjcmV0" \
    ${HELM_OPTS}
