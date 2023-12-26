#!/usr/bin/env bash
set -e

kubectl label namespace default istio-injection=enabled
kubectl apply -f manifests/bookinfo.yaml
kubectl apply -f manifests/bookinfo-gateway.yaml

# Install Kiali and the other addons
kubectl apply -f manifests/addons
