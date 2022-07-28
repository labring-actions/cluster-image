#!/bin/bash
pre_prefix=$pre_registry/$repo
prefix=$pre_registry/$repo
sudo buildah login --username $username --password $password $registry
sudo buildah tag $pre_prefix/$app:$version-$arch $prefix/$app:$version-$arch
sudo buildah push $prefix/$app:$version-$arch
if [ $? != 0 ]; then
   echo "====push sync app image failed!===="
   exit 1
fi

sudo buildah rmi -f  $pre_prefix/$app:$version-$arch
sudo buildah rmi -f  $prefix/$app:$version-$arch
