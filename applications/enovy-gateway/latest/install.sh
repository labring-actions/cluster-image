#!/bin/bash
HELM_OPTS="${HELM_OPTS:-}"

helm upgrade --install eg charts/gateway-helm --namespace gateway-system --create-namespace   ${HELM_OPTS}
