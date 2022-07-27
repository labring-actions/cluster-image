#!/bin/bash
mkdir -p /tmp/shim/${arch}
wget https://github.com/labring/sealos/releases/download/v$sealos/sealos_${sealos}_linux_${arch}.tar.gz
tar -zxvf sealos_${sealos}_linux_${arch}.tar.gz image-cri-shim
if [ $? != 0 ]; then
   echo "====download and targz image-cri-shim failed!===="
   exit 1
fi
chmod a+x image-cri-shim
sudo mv image-cri-shim /tmp/shim/${arch}/


mkdir -p /tmp/sealctl/${arch}
wget https://github.com/labring/sealos/releases/download/v$sealos/sealos_${sealos}_linux_${arch}.tar.gz
tar -zxvf sealos_${sealos}_linux_${arch}.tar.gz sealctl
if [ $? != 0 ]; then
   echo "====download and targz sealctl failed!===="
   exit 1
fi
chmod a+x sealctl
sudo mv sealctl /tmp/sealctl/${arch}/

mkdir -p /tmp/images/
ipvsImage=ghcr.io/labring/lvscare:v${sealos}
sed -i "s#__lvscare__#$ipvsImage#g" rootfs/Kubefile
echo "$ipvsImage" >>  /tmp/images/LvscareImageList
if [ $? != 0 ]; then
   echo "====get lvscare image failed!===="
   exit 1
fi
