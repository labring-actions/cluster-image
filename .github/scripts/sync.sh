#!/bin/bash
pre_prefix=$pre_registry/$repo
prefix=$registry/$repo
sudo sealos login $registry -u $username -p $password
sudo sealos tag $pre_prefix/$app:$version-$arch $prefix/$app:$version-$arch
sudo sealos push $prefix/$app:$version-$arch
if [ $? != 0 ]; then
   echo "====push sync app image failed!===="
   exit 1
fi

sudo sealos rmi -f  $pre_prefix/$app:$version-$arch
sudo sealos rmi -f  $prefix/$app:$version-$arch
