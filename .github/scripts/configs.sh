#!/bin/bash
cd config/$app/$version
filename=Kubefile
if  [ -f Dockerfile ]; then
  filename=Dockerfile
fi
sudo sealos login -u $username -p  $password $registry
sudo sealos build -t $registry/$repo/$app:$version --isolation=chroot -f $filename .
if [ $? != 0 ]; then
   echo "====build config image failed!===="
   exit 1
fi
sudo sealos push $registry/$repo/$app:$version
if [ $? != 0 ]; then
   echo "====push app image failed!===="
   exit 1
fi

sudo buildah images
