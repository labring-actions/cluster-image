#!/bin/bash
prefix=$registry/$repo
buildDir=.build-image
mkdir -p $buildDir
cp -rf applications/$app/$version/* $buildDir/
# shellcheck disable=SC2164
cd $buildDir
filename=Kubefile
if  [ -f Dockerfile ]; then
  filename=Dockerfile
fi
sh init.sh amd64
[ -f init.sh  ] && cp  sh init.sh amd64
sudo sealos build -t $prefix/$app:$version-amd64 --platform linux/amd64 -f $filename  .
if [ $? != 0 ]; then
   echo "====build app image failed!===="
   exit 1
fi
cd ../ && rm -rf $buildDir
mkdir -p $buildDir
cp -rf applications/$app/$version/* $buildDir/
# shellcheck disable=SC2164
cd $buildDir
[ -f init.sh  ] && cp  sh init.sh arm64
sudo sealos build -t $prefix/$app:$version-arm64 --platform linux/arm64 -f $filename  .
if [ $? != 0 ]; then
   echo "====build app image failed!===="
   exit 1
fi
sudo buildah login --username $username --password $password $registry
sudo buildah push $prefix/$app:$version-amd64
sudo buildah push $prefix/$app:$version-arm64
sudo buildah manifest create $prefix/$app:$version
sudo buildah manifest add $prefix/$app:$version docker://$prefix/$app:$version-amd64
sudo buildah manifest add $prefix/$app:$version docker://$prefix/$app:$version-arm64
sudo buildah manifest push --all $prefix/$app:$version docker://$prefix/$app:$version
if [ $? != 0 ]; then
   echo "====push app image failed!===="
   exit 1
fi
