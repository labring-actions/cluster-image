#!/usr/bin/env bash

mkdir -p manifests
wget "https://raw.githubusercontent.com/openebs/lvm-localpv/v${VERSION#*v}/deploy/lvm-operator.yaml" -O manifests/lvm-operator.yaml
