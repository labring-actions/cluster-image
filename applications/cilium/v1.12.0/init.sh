#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
wget https://github.com/cilium/cilium-cli/releases/download/v0.12.0/cilium-linux-$arch.tar.gz
wget https://github.com/cilium/hubble/releases/download/v0.10.0/hubble-linux-$arch.tar.gz
tar -zxvf cilium-linux-$arch.tar.gz -C opt/
tar -zxvf hubble-linux-$arch.tar.gz -C opt/
rm -rf cilium-linux-$arch.tar.gz hubble-linux-$arch.tar.gz
echo "download cilium cli success"
