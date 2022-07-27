#!/bin/bash
wget https://github.com/labring/sealos/releases/download/v$sealos/sealos_${sealos}_linux_amd64.tar.gz
tar -zxvf sealos_${sealos}_linux_amd64.tar.gz sealos
if [ $? != 0 ]; then
   echo "====download and targz sealos failed!===="
   exit 1
fi
chmod a+x sealos
sudo mv sealos /usr/bin/
wget https://github.com/labring/cluster-image/releases/download/depend/buildah.linux.amd64 --no-check-certificate -O buildah && chmod a+x buildah
if [ $? != 0 ]; then
   echo "====download buildah failed!===="
   exit 1
fi
sudo mv buildah /usr/bin/
