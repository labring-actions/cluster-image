#!/bin/bash
version=${1:-v3.22.1}
domain=${2:-docker.io}
repo=${3:-cuisongliu}
username=${4:-cuisongliu}
password=${5:-}
application=${6:-calico}
prefix=$domain/$repo
buildDir=.build-image
mkdir -p $buildDir
cp -rf applications/$application/$version/* $buildDir/
# shellcheck disable=SC2164
cd $buildDir
filename=Kubefile
if  [ -f Dockerfile ]; then
  filename=Dockerfile
fi
sh init.sh amd64
[ -f init.sh  ] && cp  sh init.sh amd64
sealos build -t $prefix/$application:$version-amd64 --platform linux/amd64 -f $filename  .
cd ../ && rm -rf $buildDir
mkdir -p $buildDir
cp -rf applications/$application/$version/* $buildDir/
# shellcheck disable=SC2164
cd $buildDir
[ -f init.sh  ] && cp  sh init.sh arm64
sealos build -t $prefix/$application:$version-arm64 --platform linux/arm64 -f $filename  .

buildah login --username $username --password $password $domain
buildah push $prefix/$application:$version-amd64
buildah push $prefix/$application:$version-arm64
buildah manifest create $prefix/$application:$version
buildah manifest add $prefix/$application:$version docker://$prefix/$application:$version-amd64
buildah manifest add $prefix/$application:$version docker://$prefix/$application:$version-arm64
buildah manifest push --all $prefix/$application:$version docker://$prefix/$application:$version
echo "script $prefix/$application:$version build successfully!"
