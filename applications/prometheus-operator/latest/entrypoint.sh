#!/usr/bin/env bash
set -e

kubectl -n default apply -f manifests/bundle.yaml --force-conflicts=true --server-side
kubectl -n default wait --for=condition=Ready pods -l app.kubernetes.io/name=prometheus-operator
