#!/usr/bin/env bash
set -e

# install tekton pipelin
kubectl apply -f manifests/pipeline/release.yaml
kubectl -n tekton-pipelines rollout status deployment.apps/tekton-pipelines-controller
kubectl -n tekton-pipelines rollout status deployment.apps/tekton-events-controller
kubectl -n tekton-pipelines rollout status deployment.apps/tekton-pipelines-webhook

# install tekton triggers
kubectl apply -f manifests/triggers/release.yaml
kubectl apply -f manifests/triggers/interceptors.yaml

# install tekton chains
kubectl apply -f manifests/chains/release.yaml

# install tekton dashboard
kubectl apply -f manifests/dashboard/release-full.yaml
kubectl -n tekton-pipelines patch svc tekton-dashboard -p '{"spec": {"type": "NodePort"}}'

# install tekton  CLI
cp -f ./opt/tkn /usr/local/bin/
