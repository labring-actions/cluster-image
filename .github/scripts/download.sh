#!/bin/bash

wget https://github.com/labring/sealos/releases/download/v$sealos/sealos_${sealos}_linux_amd64.tar.gz
tar -zxvf sealos_${sealos}_linux_amd64.tar.gz sealos
chmod a+x sealos
sudo mv sealos /usr/bin/
wget https://github.com/labring/cluster-image/releases/download/depend/buildah.linux.amd64 --no-check-certificate -O buildah && chmod a+x buildah
sudo mv buildah /usr/bin/
