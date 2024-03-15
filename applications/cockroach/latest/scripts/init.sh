#!/bin/bash
kubectl apply -f manifests/operator.yaml
kubectl apply -f manifests/cockroach.yaml