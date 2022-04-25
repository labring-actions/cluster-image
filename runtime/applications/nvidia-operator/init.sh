#!/bin/bash
os=linux
arch=${2:-amd64}
mkdir -p opt
wget https://get.helm.sh/helm-v3.8.2-$os-$arch.tar.gz -O helm.tar.gz && tar -zxvf helm.tar.gz
mv helm /opt/
