#!/bin/bash


to_download_arch() {
    case $ARCH in
        amd64)
            _ARCH=x86_64
            ;;
        arm64)
            _ARCH=aarch64
            ;;
        *)
            fatal "Unsupported architecture $ARCH"
    esac
}

to_download_arch
echo "download arch : $_ARCH"


wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/${ARCH}/kubectl -O /usr/bin/kubectl && chmod a+x /usr/bin/kubectl
if [ $? != 0 ]; then
   echo "====download kubectl failed!===="
   exit 1
fi

wget https://github.com/tsl0922/ttyd/releases/download/${ttydVersion}/ttyd.${_ARCH} && chmod +x ttyd.${_ARCH} && mv ttyd.${_ARCH} /usr/bin/ttyd
if [ $? != 0 ]; then
   echo "====download ttyd failed!===="
   exit 1
fi

wget -qO- "https://get.helm.sh/helm-${helmVersion}-linux-$ARCH.tar.gz" | tar -zx "linux-$ARCH/helm" && chmod +x linux-$ARCH/helm && mv linux-$ARCH/helm /usr/bin/helm
if [ $? != 0 ]; then
   echo "====download helm failed!===="
   exit 1
fi