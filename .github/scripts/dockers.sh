#!/bin/bash
prefix=$registry/$repo
buildDir=.build-image
rm -rf $buildDir || true
mkdir -p $buildDir
cp -rf dockerimages/$app/$version/* $buildDir/
# shellcheck disable=SC2164
cd $buildDir
filename=Kubefile
if  [ -f Dockerfile ]; then
  filename=Dockerfile
fi
[ -f init.sh  ] && sh init.sh $arch
sudo sealos rmi -f $prefix/docker-$app:$version-$arch || true
sudo sealos build -t $prefix/docker-$app:$version-$arch --platform linux/$arch -f $filename  .
if [ $? != 0 ]; then
   echo "====build docker image failed!===="
   exit 1
fi

sudo sealos login $registry -u $username -p $password
sudo sealos push $prefix/docker-$app:$version-$arch
if [ $? != 0 ]; then
   echo "====push docker image failed!===="
   exit 1
fi
