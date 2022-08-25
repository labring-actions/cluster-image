#!/bin/bash

set -e

ARCH=${arch?}
CRI_TYPE=${criType?}
KUBE=${kubeVersion?}
IMAGE_HUB_REGISTRY=${registry?}
IMAGE_HUB_REPO=${repo?}
IMAGE_HUB_USERNAME=${username?}
IMAGE_HUB_PASSWORD=${password?}

case $CRI_TYPE in
containerd)
  IMAGE_KUBE=kubernetes
  ;;
docker)
  IMAGE_KUBE=kubernetes-docker
  ;;
esac

buildDir=.build-image
# init dir
downloadDIR=$(pwd)/.download

mkdir -p $buildDir/bin
mkdir -p $buildDir/opt
mkdir -p $buildDir/registry
mkdir -p $buildDir/images/shim
mkdir -p $buildDir/cri/lib64

cp -rf rootfs/* $buildDir/
cp -rf "$CRI_TYPE"/* $buildDir/

# library install
if cp "${downloadDIR}/library/$ARCH/library.tar.gz" dl.tgz; then
  tar -zxf dl.tgz library/bin -C $buildDir/bin --strip-components=2
  case $CRI_TYPE in
  containerd)
    tar -zxf dl.tgz library/lib64 -C $buildDir/cri/lib64 --strip-components=2
    cd $buildDir/cri/lib64 && {
      mkdir -p lib && {
        mv libseccomp.* lib
        tar -czf containerd-lib.tar.gz lib
        rm -rf lib
      }
      cd -
    }
    ;;
  esac
  rm dl.tgz
else
  echo "====cp library failed!===="
fi

# cri install
case $CRI_TYPE in
containerd)
  cp -a "${downloadDIR}/$CRI_TYPE/$ARCH/cri-containerd-linux.tar.gz" $buildDir/cri/ || echo "====cp cri failed!===="
  # nerdctl
  cp -a "${downloadDIR}/nerdctl/$ARCH/nerdctl" $buildDir/cri/ || echo "====cp nerdctl failed!===="
  ;;
docker)
  cp -a "${downloadDIR}/$CRI_TYPE/$ARCH/*.tgz" $buildDir/cri/ || echo "====cp cri failed!===="
  ;;
esac

#kube
cp -a "${downloadDIR}/kube/$ARCH"/* $buildDir/bin/ || echo "====cp kube failed!===="

# registry
cp -a "${downloadDIR}/registry/$ARCH/registry.tar" $buildDir/images/ || echo "====cp registry failed!===="
# sealctl
cp -a "${downloadDIR}/sealctl/$ARCH/sealctl" $buildDir/opt/ || echo "====cp sealctl failed!===="
# shim
cp -a "${downloadDIR}/shim/$ARCH/image-cri-shim" $buildDir/cri/ || echo "====cp shim failed!===="
# lsof
cp -a "${downloadDIR}/lsof/$ARCH/lsof" $buildDir/opt/ || echo "====cp lsof failed!===="

# images
cp -a "${downloadDIR}/images"/*ImageList $buildDir/images/shim/ || echo "====cp images failed!===="
# replace
pauseImage=$(cat ./$buildDir/images/shim/DefaultImageList | grep /pause:)
sed -i "s#__pause__#${pauseImage}#g" ./$buildDir/etc/kubelet-flags.env
case $CRI_TYPE in
containerd)
  sed -i "s#__pause__#sealos.hub:5000/${pauseImage#*/}#g" ./$buildDir/etc/config.toml
  ;;
docker)
  sed -i "s#__pause__#{{ .registryDomain }}:{{ .registryPort }}/${pauseImage#*/}#g" ./$buildDir/etc/cri-docker.service.tmpl
  ;;
esac

cd $buildDir && {
  if cat Kubefile; then
    sudo sealos build -t "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v${KUBE}-$ARCH" --platform "linux/$ARCH" -f Kubefile .
    sudo sealos login "$IMAGE_HUB_REGISTRY" -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD"
    sudo sealos push "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v${KUBE}-$ARCH"
  fi
}
