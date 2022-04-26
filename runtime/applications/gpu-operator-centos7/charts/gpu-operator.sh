#!/bin/bash
../opt/helm install --wait --generate-name \
  -n gpu-operator --create-namespace \
  gpu-operator-v1.10.1.tgz \
  --set toolkit.version=1.7.1-centos7 --set driver.enabled=false
