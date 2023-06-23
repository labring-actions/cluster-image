#!/bin/bash
mkdir -p manifests
helm template openim openIM --set istio.publicPort="80" --set istio.publicIP="127.0.0.1" --debug > manifests/openIM.yaml
