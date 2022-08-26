#!/bin/bash
prefix=$registry/$repo
if [[ -n "$sealoslatest" ]]; then
  version="$version-v$sealoslatest"
fi
sudo buildah rmi $prefix/$app:$version ||true
sudo buildah login --username $username --password $password $registry
sudo buildah manifest create $prefix/$app:$version
sudo buildah manifest add $prefix/$app:$version docker://$prefix/$app:$version-amd64
sudo buildah manifest push --all $prefix/$app:$version docker://$prefix/$app:$version
if [ $? != 0 ]; then
   echo "====push  image manifest failed!===="
   exit 1
fi
sudo buildah rmi $prefix/$app:$version ||true
