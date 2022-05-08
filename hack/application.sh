#!/bin/bash
version=${1:-v3.22.1}
domain=${2:-docker.io}
repo=${3:-cuisongliu}
username=${4:-cuisongliu}
password=${5:-}
application=${6:-calico}
dir=${7:-default}
prefix=$domain/$repo

if [ ! -x /usr/bin/buildah ];then
  wget https://sealyun-home.oss-accelerate.aliyuncs.com/images/buildah.linux.amd64 --no-check-certificate -O /usr/bin/buildah
  chmod a+x /usr/bin/buildah
fi
if [ ! -x ./sealos ];then
  wget https://sealyun-home.oss-accelerate.aliyuncs.com/sealos-4.0/latest/sealos-amd64 --no-check-certificate -O sealos
  chmod a+x sealos
fi

mkdir -p rootfs
cp -rf runtime/applications/$application/$dir/* rootfs/
# shellcheck disable=SC2164
cd rootfs
sh init.sh amd64
../sealos build -t $prefix/oci-$application:$version-amd64 --platform linux/amd64 -f Kubefile  .
cd ../ && rm -rf rootfs
mkdir -p rootfs
cp -rf runtime/applications/$application/$dir/* rootfs/
# shellcheck disable=SC2164
cd rootfs
sh init.sh arm64
../sealos build -t $prefix/oci-$application:$version-arm64 --platform linux/arm64 -f Kubefile  .

buildah login --username $username --password $password $domain
buildah push $prefix/oci-$application:$version-amd64
buildah push $prefix/oci-$application:$version-arm64
buildah manifest create $prefix/oci-$application:$version
buildah manifest add $prefix/oci-$application:$version docker://$prefix/oci-$application:$version-amd64
buildah manifest add $prefix/oci-$application:$version docker://$prefix/oci-$application:$version-arm64
buildah manifest push --all $prefix/oci-$application:$version docker://$prefix/oci-$application:$version
