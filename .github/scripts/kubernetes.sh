#!/bin/bash

set -eux

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}
readonly SEALOS=${sealoslatest?}

readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}

readonly ROOT="/tmp/$(whoami)/build"
readonly PATCH="/tmp/$(whoami)/patch"
mkdir -p "$ROOT" "$PATCH"
readonly downloadDIR="/tmp/$(whoami)/download"
readonly binDIR="/tmp/$(whoami)/bin"

{
  FROM_KUBE=$(sudo buildah from "ghcr.io/labring-actions/cache:kubernetes-v$KUBE-amd64")
  sudo cp -a "$(sudo buildah mount "$FROM_KUBE")"/bin/kubeadm "$binDIR/kubeadm"
  sudo buildah umount "$FROM_KUBE"
  sudo chown "$(whoami)" "$binDIR"/*
  chmod a+x "$binDIR"/*
  sudo cp -auv "$binDIR"/* /usr/bin
}

if [[ -n "$sealosPatch" ]]; then
  FROM_KUBE=$(sudo buildah from "$sealosPatch-$ARCH")
  rmdir "$PATCH"
  sudo cp -a "$(sudo buildah mount "$FROM_KUBE")" "$PATCH"
  sudo chown -R "$USER:$USER" "$PATCH"
  sudo buildah umount "$FROM_KUBE"
fi

cp -a rootfs/* "$ROOT"
cp -a "$CRI_TYPE"/* "$ROOT"
cp -a registry/* "$ROOT"

cd "$ROOT" && {
  mkdir -p bin
  mkdir -p opt
  mkdir -p registry
  mkdir -p images/shim
  mkdir -p cri/lib64

  # ImageList
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
    ;;
  cri-o)
    cp -a "${downloadDIR}/$ARCH/cri-o.tar.gz" cri/
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
  cp -a "${downloadDIR}/$ARCH"/registry cri/
#  cp -a "${downloadDIR}/$ARCH"/registry.tar images/
  cp -a "${downloadDIR}/$ARCH"/image-cri-shim cri/
  cp -a "${downloadDIR}/$ARCH"/sealctl opt/
  cp -a "${downloadDIR}/$ARCH"/lsof opt/
  if ! rmdir "$PATCH"; then
    cp -a "$PATCH"/* .
    ipvsImage="localhost:5000/labring/lvscare:$(find "registry" -type d | grep -E "tags/.+-$ARCH$" | awk -F/ '{print $NF}')"
    echo >images/shim/lvscareImage
  else
    ipvsImage="ghcr.io/labring/lvscare:v$SEALOS"
    echo "$ipvsImage" >images/shim/LvscareImageList
  fi

  # replace
  sed -i "s#__lvscare__#$ipvsImage#g;s/v0.0.0/v$KUBE/g" "Kubefile"
  pauseImage=$(grep /pause: images/shim/DefaultImageList)
  pauseImageName=${pauseImage#*/}
  sed -i "s#__pause__#${pauseImageName}#g" Kubefile
  # build
  case $CRI_TYPE in
  containerd)
    IMAGE_KUBE=kubernetes
    ;;
  cri-o)
    IMAGE_KUBE=kubernetes-crio
    ;;
  docker)
    IMAGE_KUBE=kubernetes-docker
    ;;
  esac

  if ! [[ "$SEALOS" =~ ^[0-9\.]+[0-9]$ ]] || [[ -n "$sealosPatch" ]]; then
    IMAGE_PUSH_NAME=(
      "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v${KUBE%.*}-$ARCH"
    )
  else
    if [[ "$SEALOS" == "$(
      until curl -sL "https://api.github.com/repos/labring/sealos/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
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

  chmod a+x bin/* opt/*

  echo -n >"$IMAGE_HUB_REGISTRY.images"
  for IMAGE_NAME in "${IMAGE_PUSH_NAME[@]}"; do
    if [[ "$allBuild" != true ]]; then
      case $IMAGE_HUB_REGISTRY in
      docker.io)
        if until curl -sL "https://hub.docker.com/v2/repositories/$IMAGE_HUB_REPO/$IMAGE_KUBE/tags/${IMAGE_NAME##*:}"; do sleep 3; done |
          grep digest >/dev/null; then
          echo "$IMAGE_NAME already existed"
        else
          echo "$IMAGE_NAME" >>"$IMAGE_HUB_REGISTRY.images"
        fi
        ;;
      *)
        echo "$IMAGE_NAME" >>"$IMAGE_HUB_REGISTRY.images"
        ;;
      esac
    else
      echo "$IMAGE_NAME" >>"$IMAGE_HUB_REGISTRY.images"
    fi
  done

  IMAGE_BUILD="$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:build-$(date +%s)"
  if [[ -s "$IMAGE_HUB_REGISTRY.images" ]]; then
    FROM_KUBE=$(sudo buildah from "ghcr.io/labring-actions/cache:kubernetes-v$KUBE-$ARCH")
    sudo cp -a "$(sudo buildah mount "$FROM_KUBE")"/registry .
    sudo buildah umount "$FROM_KUBE"
    sudo sealos build -t "$IMAGE_BUILD" --platform "linux/$ARCH" -f Kubefile .
    while read -r IMAGE_NAME; do
      sudo sealos tag "$IMAGE_BUILD" "$IMAGE_NAME"
      sudo sealos login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
        sudo sealos push "$IMAGE_NAME" && echo "$IMAGE_NAME push success"
    done <"$IMAGE_HUB_REGISTRY.images"
    sudo sealos images
  fi
}
