#!/bin/bash
mkdir -p .download/shim/${arch}
wget https://github.com/labring/sealos/releases/download/v$sealos/sealos_${sealos}_linux_${arch}.tar.gz
tar -zxvf sealos_${sealos}_linux_${arch}.tar.gz image-cri-shim
if [ $? != 0 ]; then
   echo "====download and targz image-cri-shim failed!===="
   exit 1
fi
chmod a+x image-cri-shim
sudo mv image-cri-shim .download/shim/${arch}/

mkdir -p .download/sealctl/${arch}
tar -zxvf sealos_${sealos}_linux_${arch}.tar.gz sealctl
if [ $? != 0 ]; then
   echo "====targz sealctl failed!===="
   exit 1
fi
chmod a+x sealctl
sudo mv sealctl .download/sealctl/${arch}/

mkdir -p .download/images/
ipvsImage=ghcr.io/labring/lvscare:v${sealos}
sed -i "s#__lvscare__#$ipvsImage#g" rootfs/Kubefile
echo "$ipvsImage" >>  .download/images/LvscareImageList
if [ $? != 0 ]; then
   echo "====get lvscare image failed!===="
   exit 1
fi
