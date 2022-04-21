#!/bin/bash
version=${1:-1.22.8}
os=linux
arch=${2:-amd64}
prefix=${3:-docker.io}
mkdir -p cri/lib64
wget https://sealyun-home.oss-accelerate.aliyuncs.com/images/nvidia-container-runtime-$os-$arch.tar.gz  -O cri/nvidia-container-runtime.tar.gz
wget https://sealyun-home.oss-accelerate.aliyuncs.com/images/nvidia-container-runtime-lib64-$os-$arch.tar.gz -O nvidia-container-runtime-lib64.tar.gz
tar zxf nvidia-container-runtime-lib64.tar.gz && rm -rf nvidia-container-runtime-lib64.tar.gz
cp -rf lib64/  cri/lib64/lib
ls -l cri/lib64/lib
rm -rf lib64
cd cri/lib64 && tar -czvf nvidia-lib.tar.gz lib && rm -rf lib && cd ../../
if [ ! -x ../kubeadm ];then
  wget https://storage.googleapis.com/kubernetes-release/release/v$version/bin/linux/amd64/kubeadm -O ../kubeadm
  chmod a+x ../kubeadm
fi
pauseImage=$(../kubeadm config images list --kubernetes-version $version  2>/dev/null | grep k8s.gcr.io/pause)
sed -i "s#__pause__#sealos.hub:5000/${pauseImage##k8s.gcr.io/}#g" etc/config.toml

sed -i "s#scratch#$prefix/oci-kubernetes:$version-$arch#g" Kubefile
