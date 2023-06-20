#!/bin/bash
mkdir -p manifests
helm template openim openIM  --values openIM/values.yaml --values openIM/configmap-config.values.yaml --values openIM/configmap-notification.values.yaml --values openIM/configmap-password.values.yaml  --debug > manifests/openIM.yaml
