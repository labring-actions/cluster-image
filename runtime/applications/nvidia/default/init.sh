#!/bin/bash
os=linux
arch=${1:-amd64}
mkdir -p cri/lib64
wget https://sealyun-home.oss-accelerate.aliyuncs.com/images/nvidia-container-runtime-$os-$arch.tar.gz  -O cri/nvidia-container-runtime.tar.gz
wget https://sealyun-home.oss-accelerate.aliyuncs.com/images/nvidia-container-runtime-lib64-$os-$arch.tar.gz -O nvidia-container-runtime-lib64.tar.gz
tar zxf nvidia-container-runtime-lib64.tar.gz && rm -rf nvidia-container-runtime-lib64.tar.gz
cp -rf lib64/  cri/lib64/lib
ls -l cri/lib64/lib
rm -rf lib64
cd cri/lib64 && tar -czvf nvidia-lib.tar.gz lib && rm -rf lib && cd ../../
