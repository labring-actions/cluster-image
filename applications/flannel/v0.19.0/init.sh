#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-$arch-v1.1.1.tgz 
echo "download cni-plugins success"
