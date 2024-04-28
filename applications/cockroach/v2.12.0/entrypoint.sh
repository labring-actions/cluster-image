#!/bin/bash
set -e

IMAGE="cockroachdb/cockroach-operator:v2.12.0"

if [ "${arch}" = "amd64" ]; then
    IMAGE="docker.io/cockroachdb/cockroach-operator:v2.12.0"
elif [ "${arch}" = "arm64" ]; then
    IMAGE="ghcr.io/jrcichra/cockroach-operator:v2.12.0@sha256:264590af6bdc01b110f0f7f233950ad7857593e8607aeef3bae13a0adbb509c7"
fi

sed -i 's#{IMAGE}#'${IMAGE}'#g' manifests/deploy.yaml

kubectl apply -f manifests/deploy.yaml
