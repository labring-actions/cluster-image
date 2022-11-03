#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.6/kustomize_v4.5.6_linux_$arch.tar.gz
tar xzf kustomize_v4.5.6_linux_$arch.tar.gz
chmod a+x ./kustomize
mv ./kustomize opt/
echo "download kustomize success"
