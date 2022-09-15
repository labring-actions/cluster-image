#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
curl -L -o opt/virtctl https://github.com/kubevirt/kubevirt/releases/download/v0.57.0/virtctl-v0.57.0-linux-amd64
chmod +x opt/virtctl
echo "download virtctl success"
