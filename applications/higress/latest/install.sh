#!/bin/bash

HELM_OPTS="${HELM_OPTS:-}"
ENABLE_ISTIO="${ENABLE_ISTIO:-}"
ENABLE_GATEWAY="${ENABLE_GATEWAY:-}"
APPLY_DEFAULT_CR="${APPLY_DEFAULT_CR:-}"

helm upgrade --install higress -n higress-system higress.io/higress \
  --create-namespace --render-subchart-notes \
  --set global.ingressClass=nginx --set global.enableStatus=false --set higress-core.gateway.hostNetwork=true \
  --set higress-core.gateway.service.type=NodePort --set global.disableAlpnH2=true \
  ${HELM_OPTS}

if [[ "$ENABLE_ISTIO" == "true" ]]; then
  helm upgrade --install istio-base istio/base -n istio-system --create-namespace
  helm upgrade higress higress.io/higress -n higress-system --set global.enableIstioAPI=true --reuse-values
fi

if [[ "$ENABLE_GATEWAY" == "true" ]]; then
  kubectl apply -f plugins/standard-install.yaml
  helm upgrade higress higress.io/higress -n higress-system --set global.enableGatewayAPI=true --reuse-values
fi

if [[ "$APPLY_DEFAULT_CR" == "true" ]]; then
  kubectl apply -f plugins/crd.yaml
fi
