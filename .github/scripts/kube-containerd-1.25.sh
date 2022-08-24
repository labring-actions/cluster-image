#!/bin/bash
buildDir=.build-image
# init dir
downloadDIR=$(pwd)/.download
mkdir -p $buildDir/bin && mkdir -p $buildDir/opt && mkdir -p $buildDir/registry && mkdir -p $buildDir/images/shim && mkdir -p $buildDir/cri/lib64
cp -rf rootfs/* $buildDir/
cp -rf containerd/* $buildDir/
# library install
cp ${downloadDIR}/library/${arch}/library.tar.gz .
if [ $? != 0 ]; then
   echo "====cp library failed!===="
   exit 1
fi
tar xf library.tar.gz && rm -rf library.tar.gz
cp -rf library/bin/*    $buildDir/bin/
ls -l  $buildDir/bin/
cp -rf library/lib64/  $buildDir/cri/lib64/lib
ls -l $buildDir/cri/lib64/lib
rm -rf library
cd $buildDir/cri/lib64 && tar -czf containerd-lib.tar.gz lib && rm -rf lib && cd ../../../
#kube install
cp  ${downloadDIR}/kube/${arch}/* $buildDir/bin/
if [ $? != 0 ]; then
   echo "====cp kube failed!===="
   exit 1
fi
# registry install
cp ${downloadDIR}/registry/${arch}/registry.tar $buildDir/images/registry.tar
if [ $? != 0 ]; then
   echo "====cp registry failed!===="
   exit 1
fi
# cri install
cp ${downloadDIR}/containerd/${arch}/cri-containerd-linux.tar.gz $buildDir/cri/
if [ $? != 0 ]; then
   echo "====cp cri failed!===="
   exit 1
fi
# nerdctl install
cp ${downloadDIR}/nerdctl/${arch}/nerdctl $buildDir/cri/
if [ $? != 0 ]; then
   echo "====cp nerdctl failed!===="
   exit 1
fi
# shim install
cp ${downloadDIR}/shim/${arch}/image-cri-shim $buildDir/cri/
if [ $? != 0 ]; then
   echo "====cp shim failed!===="
   exit 1
fi
# sealctl
cp ${downloadDIR}/sealctl/${arch}/sealctl $buildDir/opt/
if [ $? != 0 ]; then
   echo "====cp sealctl failed!===="
   exit 1
fi
# lsof
cp ${downloadDIR}/lsof/${arch}/lsof $buildDir/opt/
if [ $? != 0 ]; then
   echo "====cp lsof failed!===="
   exit 1
fi
chmod a+x $buildDir/opt/*
# images
cp -rf  ${downloadDIR}/images/*ImageList   $buildDir/images/shim/
if [ $? != 0 ]; then
   echo "====cp images failed!===="
   exit 1
fi
# replace
pauseImage=$(cat ./$buildDir/images/shim/DefaultImageList  | grep registry.k8s.io/pause)
sed -i "s#__pause__#registry.k8s.io/${pauseImage##registry.k8s.io/}#g" ./$buildDir/etc/kubelet-flags.env
sed -i "s#__pause__#sealos.hub:5000/${pauseImage##registry.k8s.io/}#g" ./$buildDir/etc/config.toml
cd $buildDir
chmod  -R 0755  *
cat Kubefile
sudo sealos build -t $registry/$repo/kubernetes:v${kubeVersion}-${arch} --platform linux/${arch} -f Kubefile  .

sudo sealos login $registry -u $username -p $password
sudo sealos push $registry/$repo/kubernetes:v${kubeVersion}-${arch}
