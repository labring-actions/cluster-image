#!/bin/bash
buildDir=.build-image
# init dir
mkdir -p $buildDir/bin && mkdir -p $buildDir/opt && mkdir -p $buildDir/registry && mkdir -p $buildDir/images/shim && mkdir -p $buildDir/cri/lib64
cp -rf rootfs/* $buildDir/
cp -rf containerd/* $buildDir/
# library install
mv /tmp/library/${arch}/library.tar.gz .
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
mv /tmp/kube/${arch}/* $buildDir/bin/
if [ $? != 0 ]; then
   echo "====cp kube failed!===="
   exit 1
fi
# registry install
mv /tmp/registry/${arch}/registry.tar $buildDir/images/registry.tar
if [ $? != 0 ]; then
   echo "====cp registry failed!===="
   exit 1
fi
# cri install
mv /tmp/containerd/${arch}/cri-containerd-linux.tar.gz $buildDir/cri/
if [ $? != 0 ]; then
   echo "====cp cri failed!===="
   exit 1
fi
# nerdctl install
mv /tmp/nerdctl/${arch}/nerdctl $buildDir/cri/
if [ $? != 0 ]; then
   echo "====cp nerdctl failed!===="
   exit 1
fi
# shim install
mv /tmp/shim/${arch}/image-cri-shim $buildDir/cri/
if [ $? != 0 ]; then
   echo "====cp shim failed!===="
   exit 1
fi
# sealctl
mv /tmp/sealctl/${arch}/image-cri-shim $buildDir/opt/
if [ $? != 0 ]; then
   echo "====cp sealctl failed!===="
   exit 1
fi
# lsof
mv /tmp/lsof/${arch}/lsof $buildDir/opt/
if [ $? != 0 ]; then
   echo "====cp lsof failed!===="
   exit 1
fi
chmod a+x $buildDir/opt/*
# images
cp -rf  /tmp/kubeadm/*ImageList   $buildDir/images/shim/
# replace
pauseImage=$(cat ./$buildDir/images/shim/DefaultImageList  | grep k8s.gcr.io/pause)
sed -i "s#__pause__#k8s.gcr.io/${pauseImage##k8s.gcr.io/}#g" ./$buildDir/etc/kubelet-flags.env
sed -i "s#__pause__#sealos.hub:5000/${pauseImage##k8s.gcr.io/}#g" ./$buildDir/etc/config.toml
cd $buildDir
chmod  -R 0755  *
sudo sealos build -t $registry/$repo/kubernetes:v${kubeVersion}-${arch} --platform linux/${arch} -f Kubefile  .

sudo buildah login --username $username --password $password $registry
sudo buildah push $registry/$repo/kubernetes:v${kubeVersion}-${arch}
