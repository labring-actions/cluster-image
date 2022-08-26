#!/bin/bash
prefix=$registry/$repo

readonly CRI_TYPE=${criType?}
readonly version=${sealoslatest:-${version?}}

case $CRI_TYPE in
containerd)
  app=kubernetes
  ;;
docker)
  app=kubernetes-docker
  ;;
esac

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
