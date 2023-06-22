#!/bin/bash
mkdir -p manifests
helm template openim openIM  --debug > manifests/openIM.yaml
