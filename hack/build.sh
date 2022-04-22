#!/bin/bash
#sh build.sh 1.22.8 registry-vpc.cn-hongkong.aliyuncs.com sealyun sealyun@1244797166814602 xxxx
version=${1:-1.22.8}
domain=${2:-docker.io}
repo=${3:-cuisongliu}
username=${4:-cuisongliu}
password=${5:-}
proxy=${6:-}
if [ ! -x /usr/bin ];then
  wget https://sealyun-home.oss-accelerate.aliyuncs.com/images/buildah.linux.amd64 --no-check-certificate -O buildah
  chmod a+x buildah
  mv buildah /usr/bin
fi
if [ ! -x ./sealos ];then
  wget https://sealyun-home.oss-accelerate.aliyuncs.com/sealos-4.0/latest/sealos-amd64 --no-check-certificate -O sealos
  chmod a+x sealos
fi

prefix=$domain/$repo
sh containerd.sh $version amd64 $prefix $proxy
sh containerd.sh $version arm64 $prefix $proxy
buildah login --username $username --password $password $domain
buildah push $prefix/oci-kubernetes:$version-amd64
buildah push $prefix/oci-kubernetes:$version-arm64
buildah manifest create $prefix/oci-kubernetes:$version
buildah manifest add $prefix/oci-kubernetes:$version docker://$prefix/oci-kubernetes:$version-amd64
buildah manifest add $prefix/oci-kubernetes:$version docker://$prefix/oci-kubernetes:$version-arm64
buildah manifest push --all $prefix/oci-kubernetes:$version docker://$prefix/oci-kubernetes:$version
