#!/bin/bash

wget https://github.com/labring/sealos/releases/download/v$sealos/sealos_$sealos_linux_amd64.tar.gz
tar -zxvf sealos_${VERSION}_linux_amd64.tar.gz sealos
chmod a+x sealos
sudo mv sealos /usr/bin/
wget https://github.com/labring/cluster-image/releases/download/depend/buildah.linux.amd64 --no-check-certificate -O buildah && chmod a+x buildah
sudo mv buildah /usr/bin/
wget https://github.com/lework/skopeo-binary/releases/download/v1.9.1/skopeo-linux-amd64 -O skopeo
chmod a+x skopeo
sudo mv skopeo /usr/bin/
