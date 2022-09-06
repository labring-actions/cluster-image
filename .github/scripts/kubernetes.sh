#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}
readonly SEALOS=${sealoslatest?}

readonly ipvsImage="ghcr.io/labring/lvscare:v$SEALOS"

readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}

readonly ROOT="/tmp/$(whoami)/build"
mkdir -p "$ROOT"
readonly downloadDIR="/tmp/$(whoami)/download"
readonly binDIR="/tmp/$(whoami)/bin"

{
  wget -qP "$binDIR" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/amd64/kubeadm"
  chmod a+x "$binDIR"/*
  sudo cp -auv "$binDIR"/* /usr/bin
}

cp -a rootfs/* "$ROOT"
cp -a "$CRI_TYPE"/* "$ROOT"

tree "/tmp/$(whoami)"
cd "$ROOT" && {
  mkdir -p bin
  mkdir -p opt
  mkdir -p registry
  mkdir -p images/shim
  mkdir -p cri/lib64

  # ImageList
  echo "$ipvsImage" >images/shim/LvscareImageList
  kubeadm config images list --kubernetes-version "$KUBE" 2>/dev/null >images/shim/DefaultImageList

  # library
  TARGZ="${downloadDIR}/$ARCH/library.tar.gz"
  {
    cd bin && {
      tar -zxf "$TARGZ" library/bin --strip-components=2
      cd -
    }
    case $CRI_TYPE in
    containerd)
      cd cri/lib64 && {
        tar -zxf "$TARGZ" library/lib64 --strip-components=2
        mkdir -p lib
        mv libseccomp.* lib
        tar -czf containerd-lib.tar.gz lib
        rm -rf lib
        cd -
      }
      ;;
    esac
  }

  # cri
  case $CRI_TYPE in
  containerd)
    cp -a "${downloadDIR}/$ARCH/cri-containerd.tar.gz" cri/
    cp -a "${downloadDIR}/$ARCH/nerdctl" cri/
    ;;
  docker)
    case $KUBE in
    1.*.*)
      cp -a "${downloadDIR}/$ARCH/cri-dockerd.tgz" cri/
      cp -a "${downloadDIR}/$ARCH/docker.tgz" cri/
      cp -a "${downloadDIR}/$ARCH/crictl.tar.gz" cri/
      ;;
    esac
    ;;
  esac

  cp -a "${downloadDIR}/$ARCH"/kube* bin/
#  cp -a "${downloadDIR}/$ARCH"/registry bin/
  cp -a "${downloadDIR}/$ARCH"/registry.tar images/
  cp -a "${downloadDIR}/$ARCH"/image-cri-shim cri/
  cp -a "${downloadDIR}/$ARCH"/sealctl opt/
  cp -a "${downloadDIR}/$ARCH"/lsof opt/

  # replace
  sed -i "s#__lvscare__#$ipvsImage#g;s/v0.0.0/v$KUBE/g" "Kubefile"
  pauseImage=$(grep /pause: images/shim/DefaultImageList)
  sed -i "s#__pause__#${pauseImage}#g" etc/kubelet-flags.env
  case $CRI_TYPE in
  containerd)
    sed -i "s#__pause__#{{ .registryDomain }}:{{ .registryPort }}/${pauseImage#*/}#g" etc/config.toml.tmpl
    ;;
  docker)
    sed -i "s#__pause__#{{ .registryDomain }}:{{ .registryPort }}/${pauseImage#*/}#g" etc/cri-docker.service.tmpl
    ;;
  esac

  # build
  case $CRI_TYPE in
  containerd)
    IMAGE_KUBE=kubernetes
    ;;
  docker)
    IMAGE_KUBE=kubernetes-docker
    ;;
  esac

  if ! [[ "$SEALOS" =~ ^[0-9\.]+[0-9]$ ]]; then
    IMAGE_KUBE="$IMAGE_KUBE-dev"
    IMAGE_PUSH_NAME=(
      "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v${KUBE%.*}-$ARCH"
    )
  else
    if [[ "$SEALOS" == "$(
      curl --silent "https://api.github.com/repos/labring/sealos/releases/latest" | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
    )" ]]; then
      IMAGE_PUSH_NAME=(
        "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE-$ARCH"
        "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE-$SEALOS-$ARCH"
      )
    else
      IMAGE_PUSH_NAME=(
        "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE-$SEALOS-$ARCH"
      )
    fi
  fi

  tree
  chmod a+x bin/* opt/*

  IMAGE_BUILD="$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:build-$(date +%s)"
  sudo sealos build -t "$IMAGE_BUILD" --platform "linux/$ARCH" -f Kubefile .

  for IMAGE_NAME in "${IMAGE_PUSH_NAME[@]}"; do
    sudo sealos tag "$IMAGE_BUILD" "$IMAGE_NAME"
    sudo sealos login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
      sudo sealos push "$IMAGE_NAME" && echo "$IMAGE_NAME push success"
  done
  sudo sealos images
}
