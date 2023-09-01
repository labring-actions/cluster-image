#!/bin/bash
HELM_OPTS="${HELM_OPTS:-}"

helm upgrade --install eg charts/gateway-helm --namespace envoy-gateway-system --create-namespace   ${HELM_OPTS}
