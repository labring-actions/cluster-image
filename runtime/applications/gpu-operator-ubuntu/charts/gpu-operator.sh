#!/bin/bash
../opt/helm install --wait --generate-name \
  -n gpu-operator --create-namespace \
  gpu-operator-v1.10.1.tgz \
  --set driver.enabled=false
